import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/providers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/app_settings.dart';
import '../../shared/widgets/widgets.dart';

/// Lets the student change their name, class and language after setup.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _grade = 5;
  AppLanguage _language = AppLanguage.urdu;
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    final student = await ref.read(currentStudentProvider.future);
    if (student != null) {
      await ref.read(learningRepositoryProvider).updateStudentProfile(
            studentId: student.id,
            name: _nameController.text.trim(),
            grade: _grade,
            languageCode: _language.code,
          );
      await ref
          .read(settingsControllerProvider.notifier)
          .setLanguage(_language);
      ref.invalidate(currentStudentProvider);
      ref.invalidate(subjectProgressListProvider);
      ref.invalidate(continueTargetProvider);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.profileUpdated)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final studentAsync = ref.watch(currentStudentProvider);

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
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: SafeArea(
        child: studentAsync.when(
          loading: () => const LoadingState(),
          error: (_, _) => ErrorState(
            onRetry: () => ref.invalidate(currentStudentProvider),
          ),
          data: (student) {
            if (!_initialized && student != null) {
              _initialized = true;
              _nameController.text = student.name;
              _grade = student.grade;
              _language = AppLanguage.fromCode(student.languageCode);
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(l10n.studentName,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration:
                        InputDecoration(hintText: l10n.studentNameHint),
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
                          selectedColor: AppColors.green,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _grade == g
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
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
                          selected: _language == lang,
                          selectedColor: AppColors.blue,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _language == lang
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                          onSelected: (_) =>
                              setState(() => _language = lang),
                        ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  PrimaryButton(
                    label: l10n.actionSave,
                    icon: Icons.check_rounded,
                    onPressed: _saving ? null : _save,
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
