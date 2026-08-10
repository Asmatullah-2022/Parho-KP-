import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/widgets/widgets.dart';

/// Student profile setup: name, class (Grade 1-8) and language. No phone or
/// email required. Creates the local student record and routes home.
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  // Pre-filled with the demo student's name; fully editable.
  final _nameController = TextEditingController(text: 'Ahmed');
  int _grade = 5;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final settings = ref.read(settingsControllerProvider);
    final repo = ref.read(learningRepositoryProvider);
    await repo.createStudent(
      name: _nameController.text.trim(),
      grade: _grade,
      languageCode: settings.language.code,
    );
    await ref.read(settingsControllerProvider.notifier).setHasProfile(true);
    ref.invalidate(currentStudentProvider);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.startLearning)),
    );
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);

    String languageName(AppLanguage lang) {
      switch (lang) {
        case AppLanguage.english:
          return l10n.languageEnglish;
        case AppLanguage.urdu:
          return l10n.languageUrdu;
        case AppLanguage.pashto:
          return l10n.languagePashto;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createProfile)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.green.withValues(alpha: 0.12),
                  child: const Icon(Icons.person_rounded,
                      size: 52, color: AppColors.green),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.createProfileSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              Text(l10n.studentName,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: l10n.studentNameHint),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 24),
              Text(l10n.selectClass,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var g = 1; g <= 8; g++)
                    ChoiceChip(
                      label: Text(l10n.grade(g)),
                      selected: _grade == g,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _grade == g
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      selectedColor: AppColors.green,
                      onSelected: (_) => setState(() => _grade = g),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.languageLabel,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final lang in AppLanguage.values)
                    ChoiceChip(
                      label: Text(languageName(lang)),
                      selected: settings.language == lang,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: settings.language == lang
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      selectedColor: AppColors.blue,
                      onSelected: (_) => ref
                          .read(settingsControllerProvider.notifier)
                          .setLanguage(lang),
                    ),
                ],
              ),
              const SizedBox(height: 36),
              PrimaryButton(
                label: l10n.startLearning,
                icon: Icons.school_rounded,
                onPressed: _saving ? null : _start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
