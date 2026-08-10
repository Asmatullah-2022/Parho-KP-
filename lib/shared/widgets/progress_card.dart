import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';
import '../../l10n/app_localizations.dart';
import 'progress_bar.dart';

/// A row on the Progress screen: subject name, progress bar, percentage and a
/// status chip (Strong / Improving / Needs Practice) with an icon.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.name,
    required this.percent,
  });

  final String name;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = statusFromPercent(percent);

    late final String statusLabel;
    late final Color statusColor;
    late final IconData statusIcon;
    switch (status) {
      case ProgressStatus.strong:
        statusLabel = l10n.statusStrong;
        statusColor = AppColors.strong;
        statusIcon = Icons.emoji_events_rounded;
      case ProgressStatus.improving:
        statusLabel = l10n.statusImproving;
        statusColor = AppColors.improving;
        statusIcon = Icons.trending_up_rounded;
      case ProgressStatus.needsPractice:
        statusLabel = l10n.statusNeedsPractice;
        statusColor = AppColors.needsPractice;
        statusIcon = Icons.fitness_center_rounded;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  l10n.percent(percent),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LabeledProgressBar(percent: percent, status: status),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
