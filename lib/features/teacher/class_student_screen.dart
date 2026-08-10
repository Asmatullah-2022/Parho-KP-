import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';
import 'teacher_data.dart';

/// A single student's performance within a class (DEMO data).
class ClassStudentScreen extends ConsumerWidget {
  const ClassStudentScreen({
    super.key,
    required this.classId,
    required this.studentIndex,
  });
  final int classId;
  final int studentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(teacherClassProvider(classId));
    final student = (data != null &&
            studentIndex >= 0 &&
            studentIndex < data.students.length)
        ? data.students[studentIndex]
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(student?.name ?? l10n.emptyTitle)),
      body: SafeArea(
        child: student == null
            ? EmptyState(icon: '🧑‍🎓', body: l10n.emptyBody)
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const DemoBadge(),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor:
                              AppColors.green.withValues(alpha: 0.14),
                          child: Text(
                            student.name.characters.first,
                            style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.greenDark),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(student.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        Text('${l10n.teacherAverageProgress}: '
                            '${l10n.percent(student.average)}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.teacherSubjectPerformance,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (final s in student.subjects)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProgressCard(name: s.name, percent: s.percent),
                    ),
                  if (student.weakest != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color:
                            AppColors.needsPractice.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.fitness_center_rounded,
                              color: AppColors.needsPractice),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${l10n.teacherWeakAreas}: '
                              '${student.weakest!.name} '
                              '(${l10n.percent(student.weakest!.percent)})',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
