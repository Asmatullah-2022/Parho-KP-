import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/widgets/widgets.dart';

/// Language selection with attractive cards and a checkmark on the current
/// choice. Used both in the first-run flow and (reused) from Settings.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);

    String nativeName(AppLanguage lang) {
      switch (lang) {
        case AppLanguage.english:
          return l10n.languageEnglish;
        case AppLanguage.urdu:
          return l10n.languageUrdu;
        case AppLanguage.pashto:
          return l10n.languagePashto;
      }
    }

    String subName(AppLanguage lang) {
      switch (lang) {
        case AppLanguage.english:
          return l10n.languageEnglishNative;
        case AppLanguage.urdu:
          return l10n.languageUrduNative;
        case AppLanguage.pashto:
          return l10n.languagePashtoNative;
      }
    }

    return Scaffold(
      appBar: fromSettings
          ? AppBar(title: Text(l10n.languageLabel))
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                l10n.chooseLanguage,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.chooseLanguageSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: AppLanguage.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final lang = AppLanguage.values[i];
                    final selected = settings.language == lang;
                    return _LanguageCard(
                      name: nativeName(lang),
                      subName: subName(lang),
                      selected: selected,
                      onTap: () => ref
                          .read(settingsControllerProvider.notifier)
                          .setLanguage(lang),
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: fromSettings ? l10n.actionSave : l10n.actionContinue,
                icon: Icons.arrow_forward_rounded,
                onPressed: () async {
                  if (fromSettings) {
                    context.pop();
                  } else {
                    await ref
                        .read(settingsControllerProvider.notifier)
                        .completeOnboarding();
                    if (context.mounted) context.go(Routes.setup);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.name,
    required this.subName,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String subName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.green.withValues(alpha: 0.12),
                child: const Icon(Icons.translate_rounded,
                    color: AppColors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(subName,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.green, size: 30)
              else
                Icon(Icons.circle_outlined,
                    color: Theme.of(context).colorScheme.outlineVariant,
                    size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
