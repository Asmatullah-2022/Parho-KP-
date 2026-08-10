import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../providers/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows Online / Offline state with an icon + text (not colour alone).
class OfflineBadge extends ConsumerWidget {
  const OfflineBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final online = ref.watch(connectivityMockProvider);
    final color = online ? AppColors.green : AppColors.improving;
    final icon = online ? Icons.wifi_rounded : Icons.wifi_off_rounded;
    final label = online ? l10n.statusOnline : l10n.statusOffline;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small "DEMO CONTENT" chip shown on lessons so demo material is clearly
/// distinguished from real curriculum.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.yellowDark, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.science_outlined, size: 15, color: AppColors.yellowDark),
          const SizedBox(width: 4),
          Text(
            l10n.demoContent,
            style: const TextStyle(
              color: AppColors.yellowDark,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
