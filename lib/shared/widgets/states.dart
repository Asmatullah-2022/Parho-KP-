import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'primary_button.dart';

/// Centered spinner with a label.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message ?? l10n.loading,
              style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// Friendly empty placeholder.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.icon = '📭', this.title, this.body});
  final String icon;
  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              title ?? l10n.emptyTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body ?? l10n.emptyBody,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error placeholder with an optional retry action.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.title, this.body, this.onRetry});
  final String? title;
  final String? body;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 56),
            const SizedBox(height: 16),
            Text(
              title ?? l10n.errorTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body ?? l10n.errorBody,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              PrimaryButton(
                label: l10n.actionRetry,
                icon: Icons.refresh_rounded,
                expand: false,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
