import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// A simple teacher dashboard (demo data). Shows a class summary and the
/// learning areas the class is working on. AI/analytics here support the
/// teacher; they do not replace them.
class TeacherScreen extends ConsumerWidget {
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final groupsAsync = ref.watch(lessonsBySubjectProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.teacherDashboardTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const DemoBadge(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blue, AppColors.blueDark],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.teacherMyClasses,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Class 5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.teacherStudents(32),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.people_rounded,
                    color: AppColors.green,
                    value: '32',
                    label: l10n.teacherStudents(32),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.trending_up_rounded,
                    color: AppColors.improving,
                    value: l10n.percent(67),
                    label: l10n.teacherAverageProgress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.teacherLearningAreas,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            groupsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: LoadingState(),
              ),
              error: (_, _) => const SizedBox.shrink(),
              data: (groups) {
                final areas = <({String subject, String topic})>[];
                for (final g in groups) {
                  if (g.lessons.isEmpty) continue;
                  areas.add((
                    subject: pickLang(code, g.subject.nameEn,
                        g.subject.nameUr, g.subject.namePs),
                    topic: pickLang(code, g.lessons.first.titleEn,
                        g.lessons.first.titleUr, g.lessons.first.titlePs),
                  ));
                }
                return Column(
                  children: [
                    for (final a in areas.take(4))
                      Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.menu_book_rounded),
                          title: Text(a.subject,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(a.topic),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              l10n.teacherDemoNote,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
