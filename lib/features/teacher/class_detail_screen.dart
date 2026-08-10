import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'teacher_data.dart';

/// Class details: average, subject performance, students needing support, and
/// the full student list. DEMO data.
class ClassDetailScreen extends ConsumerWidget {
  const ClassDetailScreen({super.key, required this.classId});
  final int classId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(teacherClassProvider(classId));

    return Scaffold(
      appBar: AppBar(title: Text(data?.name ?? l10n.teacherDashboardTitle)),
      body: SafeArea(
        child: data == null
            ? EmptyState(icon: '👩‍🏫', body: l10n.emptyBody)
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const DemoBadge(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          icon: Icons.people_rounded,
                          color: AppColors.green,
                          value: '${data.students.length}',
                          label: l10n.teacherStudents(data.students.length),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _Metric(
                          icon: Icons.trending_up_rounded,
                          color: AppColors.improving,
                          value: l10n.percent(data.averageProgress),
                          label: l10n.teacherAverageProgress,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.teacherSubjectPerformance,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (final s in data.subjectAverages)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProgressCard(name: s.name, percent: s.percent),
                    ),
                  if (data.needingSupport.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(l10n.teacherNeedingSupport,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    for (final s in data.needingSupport)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.needsPractice.withValues(alpha: 0.14),
                            child: const Icon(Icons.priority_high_rounded,
                                color: AppColors.needsPractice),
                          ),
                          title: Text(s.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                              '${s.weakest?.name ?? ''} — ${l10n.percent(s.weakest?.percent ?? 0)}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push(
                              Routes.teacherStudentPath(
                                  classId, data.students.indexOf(s))),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  Text(l10n.teacherStudentList,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (var i = 0; i < data.students.length; i++)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.blue.withValues(alpha: 0.12),
                          child: Text(
                            data.students[i].name.characters.first,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDark),
                          ),
                        ),
                        title: Text(data.students[i].name),
                        trailing: Text(
                          l10n.percent(data.students[i].average),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        onTap: () => context.push(
                            Routes.teacherStudentPath(classId, i)),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
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
