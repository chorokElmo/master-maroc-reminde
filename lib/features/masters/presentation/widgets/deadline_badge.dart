import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/master_enums.dart';

(String, Color) deadlineStatusVisual(MasterListingStatus status) {
  return switch (status) {
    MasterListingStatus.open => ('Open', AppColors.statusOpen),
    MasterListingStatus.closingSoon => ('Closing Soon', AppColors.statusClosingSoon),
    MasterListingStatus.closed => ('Closed', AppColors.statusClosed),
  };
}

class DeadlineBadge extends StatelessWidget {
  const DeadlineBadge({super.key, required this.status, this.compact = false});

  final MasterListingStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, color) = deadlineStatusVisual(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 3 : 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: compact ? 11 : 12),
          ),
        ],
      ),
    );
  }
}

class ReviewFlagBadge extends StatelessWidget {
  const ReviewFlagBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Some details on this listing could not be auto-detected — double check on the '
          'official page before relying on them.',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.needsReview.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, size: 12, color: AppColors.needsReview),
            SizedBox(width: 4),
            Text(
              'Verify details',
              style: TextStyle(color: AppColors.needsReview, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
