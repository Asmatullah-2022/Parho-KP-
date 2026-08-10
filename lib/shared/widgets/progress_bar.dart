import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/view_models.dart';

/// A labelled progress bar that also states the percentage in text, so meaning
/// is never carried by colour alone.
class LabeledProgressBar extends StatelessWidget {
  const LabeledProgressBar({
    super.key,
    required this.percent,
    this.status,
    this.height = 12,
  });

  final int percent;
  final ProgressStatus? status;
  final double height;

  Color _color() {
    switch (status) {
      case ProgressStatus.strong:
        return AppColors.strong;
      case ProgressStatus.improving:
        return AppColors.improving;
      case ProgressStatus.needsPractice:
        return AppColors.needsPractice;
      case null:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Semantics(
      label: 'Progress',
      value: '$percent percent',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: LinearProgressIndicator(
          value: (percent.clamp(0, 100)) / 100,
          minHeight: height,
          backgroundColor: color.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
