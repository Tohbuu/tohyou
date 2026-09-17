import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_radius.dart';

class TohyouProgress extends StatelessWidget {
  const TohyouProgress({
    super.key,
    required this.value,
    this.height = 4,
  });

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(TohyouRadius.pill),
      child: LinearProgressIndicator(
        value: normalized,
        minHeight: height,
        backgroundColor: TohyouColors.surfaceHighlight,
        valueColor: const AlwaysStoppedAnimation(
          TohyouColors.accent,
        ),
      ),
    );
  }
}