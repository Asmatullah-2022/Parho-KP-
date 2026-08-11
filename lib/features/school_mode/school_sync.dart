/// School Mode — architecture for a teacher's device to collect progress from
/// nearby student devices over a **local** link (Wi-Fi Direct, a local hotspot,
/// or Bluetooth) with **no internet required**.
///
/// This file defines the clean interfaces only. No transport is implemented
/// today (the app is fully usable without it); a future implementation can plug
/// a real local-networking library in behind [SchoolSyncTransport] without
/// changing the rest of the app.
library;

/// The role a device plays in a school-mode session.
enum SchoolSyncRole {
  /// The teacher's device, which collects snapshots from student devices.
  teacherHost,

  /// A student's device, which publishes its own progress snapshot.
  studentDevice,
}

/// One student's progress, shared over the local link. Deliberately minimal and
/// low-bandwidth: a display name (or class-local id), grade, and per-lesson
/// results. No CNIC, address, location, phone or family data is ever included.
class StudentProgressSnapshot {
  const StudentProgressSnapshot({
    required this.studentLocalId,
    required this.displayName,
    required this.grade,
    required this.lessonPercents,
    required this.quizPercents,
    this.className,
  });

  final String studentLocalId;
  final String displayName;
  final int grade;
  final String? className;

  /// lessonId → percent complete.
  final Map<int, int> lessonPercents;

  /// lessonId → latest quiz percent.
  final Map<int, int> quizPercents;

  Map<String, Object?> toJson() => {
        'id': studentLocalId,
        'name': displayName,
        'grade': grade,
        if (className != null) 'class': className,
        'lessons': lessonPercents.map((k, v) => MapEntry('$k', v)),
        'quizzes': quizPercents.map((k, v) => MapEntry('$k', v)),
      };
}

/// A nearby device discovered on the local link.
class SchoolPeer {
  const SchoolPeer({required this.id, required this.name});
  final String id;
  final String name;
}

/// Transport over a LOCAL link only (no internet). A real implementation would
/// wrap Wi-Fi Direct / Nearby Connections / Bluetooth. Kept behind this
/// interface so the app depends on the capability, not the plugin.
abstract class SchoolSyncTransport {
  bool get isAvailable;

  /// Teacher host: discover student devices advertising on the local link.
  Future<List<SchoolPeer>> discoverPeers();

  /// Teacher host: pull a snapshot from a specific peer.
  Future<StudentProgressSnapshot?> receiveFrom(SchoolPeer peer);

  /// Student device: advertise and send this device's snapshot to the host.
  Future<bool> publish(StudentProgressSnapshot snapshot);
}

/// Default transport: unavailable. School mode is architecture-only in this
/// build; nothing crashes when it isn't wired.
class UnavailableSchoolSyncTransport implements SchoolSyncTransport {
  const UnavailableSchoolSyncTransport();
  @override
  bool get isAvailable => false;
  @override
  Future<List<SchoolPeer>> discoverPeers() async => const [];
  @override
  Future<StudentProgressSnapshot?> receiveFrom(SchoolPeer peer) async => null;
  @override
  Future<bool> publish(StudentProgressSnapshot snapshot) async => false;
}

/// Orchestrates a school-mode session on top of a [SchoolSyncTransport].
///
/// The service is safe to call regardless of transport availability: with the
/// default [UnavailableSchoolSyncTransport] it simply reports "not available"
/// so the UI can show guidance instead of failing.
class SchoolSyncService {
  SchoolSyncService({
    this.role = SchoolSyncRole.teacherHost,
    this.transport = const UnavailableSchoolSyncTransport(),
  });

  final SchoolSyncRole role;
  final SchoolSyncTransport transport;

  bool get isAvailable => transport.isAvailable;

  /// Teacher host: collect snapshots from all discoverable student devices.
  Future<List<StudentProgressSnapshot>> collectFromPeers() async {
    if (!transport.isAvailable) return const [];
    final peers = await transport.discoverPeers();
    final snapshots = <StudentProgressSnapshot>[];
    for (final peer in peers) {
      final snap = await transport.receiveFrom(peer);
      if (snap != null) snapshots.add(snap);
    }
    return snapshots;
  }

  /// Student device: share this device's snapshot with the teacher host.
  Future<bool> shareSnapshot(StudentProgressSnapshot snapshot) {
    if (!transport.isAvailable) return Future.value(false);
    return transport.publish(snapshot);
  }
}
