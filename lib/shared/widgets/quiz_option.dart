import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A large, tappable multiple-choice option.
///
/// Before answering it shows a neutral/selected style. After answering it shows
/// correct (green + check) or wrong (red + cross) with an icon so state is not
/// conveyed by colour alone.
class QuizOption extends StatelessWidget {
  const QuizOption({
    super.key,
    required this.text,
    required this.onTap,
    this.selected = false,
    this.revealed = false,
    this.isCorrect = false,
  });

  final String text;
  final VoidCallback? onTap;
  final bool selected;
  final bool revealed;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color border = scheme.outlineVariant;
    Color bg = Theme.of(context).cardColor;
    Widget? trailing;

    if (revealed) {
      if (isCorrect) {
        border = AppColors.green;
        bg = AppColors.green.withValues(alpha: 0.12);
        trailing = const Icon(Icons.check_circle_rounded,
            color: AppColors.green, size: 26);
      } else if (selected) {
        border = AppColors.needsPractice;
        bg = AppColors.needsPractice.withValues(alpha: 0.12);
        trailing = const Icon(Icons.cancel_rounded,
            color: AppColors.needsPractice, size: 26);
      }
    } else if (selected) {
      border = scheme.primary;
      bg = scheme.primary.withValues(alpha: 0.10);
    }

    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
