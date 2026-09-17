import 'package:flutter/material.dart';

import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TohyouSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              Text(
                'TOHYOU',
                style: TohyouTypography.display.copyWith(
                  color: TohyouColors.textPrimary,
                ),
              ),

              const SizedBox(height: TohyouSpacing.sm),

              Text(
                'Your personal anime & manga environment.',
                style: TohyouTypography.body.copyWith(
                  color: TohyouColors.textSecondary,
                ),
              ),

              const SizedBox(height: TohyouSpacing.xl),

              Container(
                padding: const EdgeInsets.all(TohyouSpacing.lg),
                decoration: BoxDecoration(
                  color: TohyouColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: TohyouColors.surfaceHighlight,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: TohyouColors.accent,
                    ),
                    SizedBox(width: TohyouSpacing.md),
                    Text('System initialized'),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}