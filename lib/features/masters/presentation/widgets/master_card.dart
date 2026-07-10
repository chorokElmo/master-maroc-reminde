import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/master.dart';
import 'deadline_badge.dart';

class MasterCard extends StatefulWidget {
  const MasterCard({
    super.key,
    required this.master,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.isGrid = true,
    this.index = 0,
  });

  final Master master;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool isGrid;
  final int index;

  @override
  State<MasterCard> createState() => _MasterCardState();
}

class _MasterCardState extends State<MasterCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.0,
    upperBound: 0.04,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final master = widget.master;
    final place = master.university ?? master.faculty ?? master.city ?? 'Morocco';

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(scale: 1 - _controller.value, child: child),
      child: Material(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTapDown: (_) => _controller.forward(),
          onTapCancel: () => _controller.reverse(),
          onTapUp: (_) => _controller.reverse(),
          onTap: () => context.push(AppRoutes.masterDetailPath(master.id)),
          child: widget.isGrid ? _buildGrid(context, place) : _buildList(context, place),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, String place) {
    final master = widget.master;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(tag: 'master-image-${master.id}', child: _Thumbnail(master: master)),
              Positioned(top: 8, right: 8, child: _FavoriteButton(
                isFavorite: widget.isFavorite,
                onTap: widget.onToggleFavorite,
              )),
              Positioned(
                bottom: 8,
                left: 8,
                child: DeadlineBadge(status: master.status, compact: true),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                master.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                place,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              _RemainingLabel(master: master),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, String place) {
    final master = widget.master;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'master-image-${master.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(width: 84, height: 84, child: _Thumbnail(master: master)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        master.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleSmall,
                      ),
                    ),
                    _FavoriteButton(isFavorite: widget.isFavorite, onTap: widget.onToggleFavorite),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  place,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DeadlineBadge(status: master.status, compact: true),
                    _RemainingLabel(master: master),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.master});

  final Master master;

  @override
  Widget build(BuildContext context) {
    final image = master.image;
    if (image == null || image.isEmpty) {
      return Container(
        color: context.colors.primary.softer,
        child: Icon(Icons.school_rounded, color: context.colors.primary, size: 32),
      );
    }
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: context.colors.surfaceContainerHighest),
      errorWidget: (context, url, error) => Container(
        color: context.colors.primary.softer,
        child: Icon(Icons.school_rounded, color: context.colors.primary, size: 32),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFavorite),
              color: isFavorite ? Colors.redAccent : Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _RemainingLabel extends StatelessWidget {
  const _RemainingLabel({required this.master});

  final Master master;

  @override
  Widget build(BuildContext context) {
    final deadline = master.applicationDeadline;
    if (deadline == null) {
      return Text(
        'No deadline detected',
        style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
      );
    }
    final (_, color) = deadlineStatusVisual(master.status);
    return Text(
      AppDateUtils.remainingLabel(deadline),
      style: context.textStyles.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600),
    );
  }
}
