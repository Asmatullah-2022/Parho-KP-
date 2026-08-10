import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/localized_text.dart';
import '../../shared/widgets/widgets.dart';

/// Offline lesson search. Works with no internet — queries the local database.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final code = ref.watch(languageCodeProvider);
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (v) =>
              ref.read(searchQueryProvider.notifier).state = v,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
            filled: false,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: query.trim().isEmpty
            ? EmptyState(
                icon: '🔍',
                title: l10n.searchTitle,
                body: l10n.searchPromptBody,
              )
            : results.when(
                loading: () => const LoadingState(),
                error: (_, _) => ErrorState(
                  onRetry: () => ref.invalidate(searchResultsProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return EmptyState(
                      icon: '🔎',
                      body: l10n.searchNoResults,
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
                            onTap: () => context
                                .push(Routes.lessonPath(item.lesson.id)),
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
