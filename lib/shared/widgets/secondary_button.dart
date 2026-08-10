import 'package:flutter/material.dart';

/// Outlined secondary action button. Same generous sizing as [PrimaryButton]
/// but visually lighter, for the less prominent action on a screen.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 10),
              Flexible(child: Text(label)),
            ],
          );

    final button = OutlinedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: child,
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
