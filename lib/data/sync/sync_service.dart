import 'dart:convert';

import '../database/app_database.dart';

/// The kinds of learning signals that may be synced. Only anonymous progress
/// data is ever queued — never names, schools or any personal information.
enum SyncKind { progress, quiz, achievement }

String _kindName(SyncKind k) => switch (k) {
      SyncKind.progress => 'progress',
      SyncKind.quiz => 'quiz',
      SyncKind.achievement => 'achievement',
    };

/// Result of attempting to send one item to a backend.
enum SyncSendResult {
  /// Accepted by the backend — the row can be marked synced.
  ok,

  /// A transient problem (offline, timeout). Keep the row pending and retry.
  retryLater,

  /// The backend rejected the payload permanently. Mark failed (not deleted).
  rejected,
}

/// Transport that uploads a queued item to a secure backend. Kept behind an
/// interface so a real HTTPS client can be dropped in later without changing
/// the queue logic. The transport never holds secrets in the app — a real
/// implementation authenticates against your backend, which holds any keys.
abstract class SyncClient {
  bool get isConfigured;
  Future<SyncSendResult> send({required String kind, required String payload});
}

/// Default transport: no backend configured. Everything stays pending so data
/// is preserved until a real backend is wired in. The app is fully usable
/// offline; syncing is purely additive.
class NoopSyncClient implements SyncClient {
  const NoopSyncClient();
  @override
  bool get isConfigured => false;
  @override
  Future<SyncSendResult> send({
    required String kind,
    required String payload,
  }) async =>
      SyncSendResult.retryLater;
}

/// Low-bandwidth, offline-first outbound sync.
///
/// Learning signals are appended to a local queue and uploaded opportunistically
/// when a backend and connection are available. Guarantees:
///  * Data is written locally first and **never dropped** — failures are kept
///    for retry, not deleted.
///  * Only compact, anonymous payloads are queued (no personal data).
///  * Works entirely offline; syncing is best-effort on top.
class SyncService {
  SyncService(
    this.db, {
    this.client = const NoopSyncClient(),
    this.maxAttempts = 5,
  });

  final AppDatabase db;
  final SyncClient client;

  /// Attempts after which a row is parked as 'failed' (still retryable later).
  final int maxAttempts;

  // ---- enqueue (local-first) ---------------------------------------------

  Future<int> _enqueue(SyncKind kind, Map<String, Object?> payload) {
    return db.enqueueSync(
      kind: _kindName(kind),
      payload: jsonEncode(payload),
    );
  }

  /// Queues a lesson-progress update. Anonymous: lesson id + percent only.
  Future<int> enqueueProgress({
    required int lessonId,
    required int percent,
    required bool completed,
  }) {
    return _enqueue(SyncKind.progress, {
      'lessonId': lessonId,
      'percent': percent,
      'completed': completed,
    });
  }

  /// Queues a finished quiz result. Anonymous: lesson id + score only.
  Future<int> enqueueQuiz({
    required int lessonId,
    required int score,
    required int total,
  }) {
    return _enqueue(SyncKind.quiz, {
      'lessonId': lessonId,
      'score': score,
      'total': total,
    });
  }

  /// Queues an unlocked achievement. Anonymous: achievement code only.
  Future<int> enqueueAchievement({required String code}) {
    return _enqueue(SyncKind.achievement, {'code': code});
  }

  // ---- inspect ------------------------------------------------------------

  Future<List<SyncQueueRow>> pending() => db.pendingSyncRows();
  Future<List<SyncQueueRow>> all() => db.allSyncRows();

  Future<SyncCounts> counts() async {
    final rows = await db.allSyncRows();
    var pending = 0, synced = 0, failed = 0;
    for (final r in rows) {
      switch (r.syncStatus) {
        case 'synced':
          synced++;
        case 'failed':
          failed++;
        default:
          pending++;
      }
    }
    return SyncCounts(pending: pending, synced: synced, failed: failed);
  }

  // ---- flush --------------------------------------------------------------

  /// Attempts to upload all pending rows. Returns how many were accepted.
  /// Rows that can't be sent stay in the queue (pending or failed) — never
  /// lost. Does nothing (returns 0) when no backend is configured.
  Future<int> flush() async {
    if (!client.isConfigured) return 0;
    final rows = await db.pendingSyncRows();
    var uploaded = 0;
    for (final row in rows) {
      final attempts = row.attempts + 1;
      final SyncSendResult result;
      try {
        result = await client.send(kind: row.kind, payload: row.payload);
      } catch (_) {
        // Transport threw — treat as transient and keep for retry.
        await db.markSyncRow(row.id,
            status: attempts >= maxAttempts ? 'failed' : 'pending',
            attempts: attempts);
        continue;
      }
      switch (result) {
        case SyncSendResult.ok:
          await db.markSyncRow(row.id,
              status: 'synced', attempts: attempts, synced: true);
          uploaded++;
        case SyncSendResult.rejected:
          await db.markSyncRow(row.id, status: 'failed', attempts: attempts);
        case SyncSendResult.retryLater:
          await db.markSyncRow(row.id,
              status: attempts >= maxAttempts ? 'failed' : 'pending',
              attempts: attempts);
      }
    }
    return uploaded;
  }

  /// Re-queues previously-failed rows for another attempt. Data is preserved.
  Future<void> retryFailed() => db.retryFailedSyncRows();
}

/// A snapshot of queue health for the UI.
class SyncCounts {
  const SyncCounts({
    required this.pending,
    required this.synced,
    required this.failed,
  });
  final int pending;
  final int synced;
  final int failed;

  int get total => pending + synced + failed;
}
