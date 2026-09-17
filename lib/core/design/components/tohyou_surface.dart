import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';
import '../app_spacing.dart';

class TohyouSurface extends StatelessWidget {
  const TohyouSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(TohyouSpacing.lg),
    this.color = TohyouColors.surface,
    this.border = true,
    this.radius = TohyouRadius.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final bool border;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border
            ? Border.all(
                color: TohyouColors.surfaceHighlight,
              )
            : null,
      ),
      child: child,
    );
  }
}