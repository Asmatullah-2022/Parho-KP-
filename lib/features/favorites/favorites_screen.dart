import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Lists the student's favorite lessons (saved offline in SQLite).
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final async = ref.watch(favoriteLessonsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: SafeArea(
        child: async.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(favoriteLessonsProvider),
          ),
          data: (items) {
            if (items.isEmpty) {
              return EmptyState(
                icon: '⭐',
                title: l10n.favoritesTitle,
                body: l10n.favoritesEmpty,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: LessonCard(
                      title: pickLang(code, item.lesson.titleEn,
                          item.lesson.titleUr, item.lesson.titlePs),
                      subtitle: item.subject == null
                          ? null
                          : pickLang(code, item.subject!.nameEn,
                              item.subject!.nameUr, item.subject!.namePs),
                      illustration: item.lesson.illustration,
                      completed: false,
                      onTap: () =>
                          context.push(Routes.lessonPath(item.lesson.id)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
