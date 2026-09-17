import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';
import '../app_typography.dart';
import 'tohyou_progress.dart';

class TohyouPosterCard extends StatefulWidget {
  const TohyouPosterCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.subtitle,
    this.progress,
    this.onTap,
  });

  final String title;
  final String? imageUrl;
  final String? subtitle;
  final double? progress;
  final VoidCallback? onTap;

  @override
  State<TohyouPosterCard> createState() => _TohyouPosterCardState();
}

class _TohyouPosterCardState extends State<TohyouPosterCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 140),
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      TohyouRadius.lg,
                    ),
                    child: widget.imageUrl != null
                        ? Image.network(
                            widget.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return _placeholder();
                            },
                          )
                        : _placeholder(),
                  ),
                ),

                if (widget.progress != null) ...[
                  const SizedBox(height: TohyouSpacing.xs),
                  TohyouProgress(
                    value: widget.progress!,
                    height: 3,
                  ),
                ],

                const SizedBox(height: TohyouSpacing.sm),

                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TohyouTypography.bodyStrong.copyWith(
                    color: TohyouColors.textPrimary,
                  ),
                ),

                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TohyouTypography.caption.copyWith(
                      color: TohyouColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: TohyouColors.surfaceElevated,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: TohyouColors.textMuted,
          size: 32,
        ),
      ),
    );
  }
}