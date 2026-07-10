import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils/extensions.dart';

/// Frosted glassmorphism panel for hero/summary sections (dashboard
/// header, stat rows) — the app's signature "premium" surface.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 26,
    this.tint,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final color = tint ?? context.colors.primary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: context.isDark ? 0.35 : 0.16),
                color.withValues(alpha: context.isDark ? 0.18 : 0.06),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: context.isDark ? 0.08 : 0.4)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius = 22,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
