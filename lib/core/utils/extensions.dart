import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isTablet => screenSize.shortestSide >= 600;

  double horizontalPadding() => isTablet ? 32 : 20;

  /// 2 columns on phones, scaling up on tablets/desktops — used by every
  /// grid view (Explore, Favorites) to stay responsive.
  int gridColumns() {
    final width = screenSize.width;
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    return 2;
  }
}

extension ColorX on Color {
  Color get soft => withValues(alpha: 0.14);
  Color get softer => withValues(alpha: 0.08);
}
