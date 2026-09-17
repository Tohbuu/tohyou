import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design/app_colors.dart';
import '../../../core/design/app_spacing.dart';
import '../../../core/design/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(TohyouSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOHYOU',
                  style: TohyouTypography.display.copyWith(
                    color: TohyouColors.textPrimary,
                  ),
                ),

                const SizedBox(height: TohyouSpacing.sm),

                Text(
                  'Application foundation is working.',
                  style: TohyouTypography.body.copyWith(
                    color: TohyouColors.textSecondary,
                  ),
                ),

                const SizedBox(height: TohyouSpacing.xl),

                FilledButton.icon(
                  onPressed: () {
                    context.go('/showcase');
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Open Design Showcase'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}