import 'package:flutter/material.dart';

import '../../data/models/view_models.dart';
import '../../l10n/app_localizations.dart';
import '../utils/localized_text.dart';
import 'progress_bar.dart';

/// Grid/list card for a subject: emoji, name and progress with percentage text.
class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.data,
    required this.languageCode,
    required this.onTap,
  });

  final SubjectProgress data;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = pickLang(
      languageCode,
      data.subject.nameEn,
      data.subject.nameUr,
      data.subject.namePs,
    );
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(data.subject.emoji,
                      style: const TextStyle(fontSize: 34)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LabeledProgressBar(percent: data.percent, status: data.status),
              const SizedBox(height: 8),
              Text(
                l10n.percent(data.percent),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
