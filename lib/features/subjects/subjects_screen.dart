import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/widgets.dart';

/// Lists all subjects for the student's grade with progress.
class SubjectsScreen extends ConsumerWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subjectsAsync = ref.watch(subjectProgressListProvider);
    final langCode = ref.watch(languageCodeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mySubjects)),
      body: SafeArea(
        child: subjectsAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(subjectProgressListProvider),
          ),
          data: (subjects) {
            if (subjects.isEmpty) {
              return EmptyState(icon: '📚', body: l10n.emptyBody);
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(subjectProgressListProvider),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 620 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.95,
                    children: [
                      for (final sp in subjects)
                        SubjectCard(
                          data: sp,
                          languageCode: langCode,
                          onTap: () => context
                              .push(Routes.subjectPath(sp.subject.id)),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
