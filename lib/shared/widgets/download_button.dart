import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Toggles a subject's offline-download state. Shows "Download" (with a
/// download icon) or "Downloaded ✓ / Delete" depending on [isDownloaded].
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.isDownloaded,
    required this.onDownload,
    required this.onDelete,
  });

  final bool isDownloaded;
  final VoidCallback onDownload;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (isDownloaded) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.green, size: 22),
          const SizedBox(width: 4),
          Text(
            l10n.labelDownloaded,
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          IconButton(
            tooltip: l10n.labelDelete,
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      );
    }
    return OutlinedButton.icon(
      onPressed: onDownload,
      icon: const Icon(Icons.download_rounded, size: 20),
      label: Text(l10n.labelDownload),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
    );
  }
}
