import 'package:flutter/material.dart';

/// Fallback seed used when the platform doesn't support Material You
/// dynamic color (or the user is on iOS / an older Android). A deep,
/// premium indigo — deliberately not a generic Material blue.
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF3949AB);

  static const Color statusOpen = Color(0xFF22C55E);
  static const Color statusClosingSoon = Color(0xFFF59E0B);
  static const Color statusClosed = Color(0xFFEF4444);

  static const Color needsReview = Color(0xFF9333EA);
}
