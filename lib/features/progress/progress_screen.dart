import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Overall + per-subject progress with Strong / Improving / Needs Practice.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final subjectsAsync = ref.watch(subjectProgressListProvider);
    final overallAsync = ref.watch(overallPercentProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProgressTitle)),
      body: SafeArea(
        child: subjectsAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(subjectProgressListProvider),
          ),
          data: (subjects) {
            if (subjects.isEmpty) {
              return EmptyState(icon: '📊', body: l10n.noProgressYet);
            }
            final overall = overallAsync.value ?? 0;
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(subjectProgressListProvider);
                ref.invalidate(overallPercentProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _OverallCard(percent: overall),
                  const SizedBox(height: 20),
                  Text(
                    l10n.mySubjects,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  for (final sp in subjects)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProgressCard(
                        name: pickLang(code, sp.subject.nameEn,
                            sp.subject.nameUr, sp.subject.namePs),
                        percent: sp.percent,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OverallCard extends StatelessWidget {
  const _OverallCard({required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.green, AppColors.greenDark],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.overallProgress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.percent(percent),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 76,
            height: 76,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                  ),
                ),
                const Icon(Icons.emoji_events_rounded,
                    color: Colors.white, size: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
