import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_colors.dart';
import '../app_spacing.dart';
import '../app_typography.dart';
import 'tohyou_icon_button.dart';

class TohyouHeader extends StatelessWidget {
  const TohyouHeader({
    super.key,
    this.title = 'TOHYOU',
    this.subtitle,
    this.showSearch = true,
    this.showSettings = true,
  });

  final String title;
  final String? subtitle;
  final bool showSearch;
  final bool showSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TohyouTypography.title.copyWith(
                  color: TohyouColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
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

        if (showSearch)
          TohyouIconButton(
            icon: Icons.search,
            tooltip: 'Search',
            onPressed: () {
              context.go('/search');
            },
          ),

        if (showSettings)
          TohyouIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            onPressed: () {
              context.go('/settings');
            },
          ),
      ],
    );
  }
}