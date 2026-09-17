import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_typography.dart';
import 'tohyou_icon_button.dart';

class TohyouSection extends StatelessWidget {
  const TohyouSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onMore,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TohyouTypography.title.copyWith(
                      color: TohyouColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: TohyouSpacing.xs),
                    Text(
                      subtitle!,
                      style: TohyouTypography.caption.copyWith(
                        color: TohyouColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onMore != null)
              TohyouIconButton(
                icon: Icons.arrow_forward,
                tooltip: 'View more',
                onPressed: onMore,
              ),
          ],
        ),

        const SizedBox(height: TohyouSpacing.md),

        child,
      ],
    );
  }
}