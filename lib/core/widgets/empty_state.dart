import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: context.colors.primary.softer, shape: BoxShape.circle),
              child: Icon(icon, size: 44, color: context.colors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: context.textStyles.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
