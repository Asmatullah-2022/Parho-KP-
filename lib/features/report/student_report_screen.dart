import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// A simple, visual learning report for the student.
class StudentReportScreen extends ConsumerWidget {
  const StudentReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final async = ref.watch(studentReportProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportTitle)),
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(studentReportProvider),
          ),
          data: (report) {
            if (report == null) {
              return EmptyState(icon: '📊', body: l10n.noProgressYet);
            }
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _HeaderCard(report: report),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        icon: Icons.menu_book_rounded,
                        color: AppColors.green,
                        value:
                            '${report.lessonsCompleted}/${report.totalLessons}',
                        label: l10n.reportLessonsCompleted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        icon: Icons.quiz_rounded,
                        color: AppColors.blue,
                        value: l10n.percent(report.quizAveragePercent),
                        label: l10n.reportQuizAverage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(l10n.mySubjects,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (final sp in report.subjects)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProgressCard(
                      name: pickLang(code, sp.subject.nameEn, sp.subject.nameUr,
                          sp.subject.namePs),
                      percent: sp.percent,
                    ),
                  ),
                if (report.strong.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _Chips(
                    title: l10n.reportStrongTopics,
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.strong,
                    items: report.strong
                        .map((s) => pickLang(code, s.subject.nameEn,
                            s.subject.nameUr, s.subject.namePs))
                        .toList(),
                  ),
                ],
                if (report.needsPractice.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _Chips(
                    title: l10n.reportNeedsPractice,
                    icon: Icons.fitness_center_rounded,
                    color: AppColors.needsPractice,
                    items: report.needsPractice
                        .map((s) => pickLang(code, s.subject.nameEn,
                            s.subject.nameUr, s.subject.namePs))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                if (report.nextLesson != null) ...[
                  Text(l10n.reportRecommended,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  LessonCard(
                    title: pickLang(
                        code,
                        report.nextLesson!.lesson.titleEn,
                        report.nextLesson!.lesson.titleUr,
                        report.nextLesson!.lesson.titlePs),
                    subtitle: pickLang(
                        code,
                        report.nextLesson!.subject.nameEn,
                        report.nextLesson!.subject.nameUr,
                        report.nextLesson!.subject.namePs),
                    illustration: report.nextLesson!.lesson.illustration,
                    completed: false,
                    onTap: () => context
                        .push(Routes.lessonPath(report.nextLesson!.lesson.id)),
                  ),
                ],
                if (report.recentActivity.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(l10n.reportRecentActivity,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  for (final a in report.recentActivity)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.check_circle_outline_rounded),
                        title: Text(a.title),
                        trailing: Text(a.detail,
                            style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.report});
  final StudentReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.green, AppColors.greenDark]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.student.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(l10n.gradeShort(report.student.grade),
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9))),
                const SizedBox(height: 10),
                Text(l10n.overallProgress,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                Text(l10n.percent(report.overallPercent),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900)),
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
                    value: report.overallPercent / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.yellow),
                  ),
                ),
                const Icon(Icons.school_rounded, color: Colors.white, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in items)
              Chip(
                label: Text(item),
                backgroundColor: color.withValues(alpha: 0.12),
                side: BorderSide(color: color.withValues(alpha: 0.4)),
              ),
          ],
        ),
      ],
    );
  }
}
