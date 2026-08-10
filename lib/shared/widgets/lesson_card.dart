import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// List row for a lesson: illustration emoji, title, and a status trailing
/// (completed check or a "continue" chevron). Icon + text convey status.
class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.title,
    required this.illustration,
    required this.completed,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String illustration;
  final bool completed;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Text(illustration, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (completed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.green, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      l10n.labelCompleted,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.labelContinue,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.primary),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
