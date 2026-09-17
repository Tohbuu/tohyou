import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_motion.dart';
import '../app_radius.dart';
import '../app_spacing.dart';

class TohyouButton extends StatefulWidget {
  const TohyouButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool secondary;

  @override
  State<TohyouButton> createState() => _TohyouButtonState();
}

class _TohyouButtonState extends State<TohyouButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.secondary
        ? TohyouColors.surfaceElevated
        : TohyouColors.accent;

    final foreground = widget.secondary
        ? TohyouColors.textPrimary
        : Colors.black;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: TohyouMotion.fast,
        curve: TohyouMotion.curve,
        transform: Matrix4.identity()
          ..scaleByDouble(
            _hovered ? 1.02 : 1.0,
            _hovered ? 1.02 : 1.0,
            _hovered ? 1.02 : 1.0,
            1.0,
          ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(TohyouRadius.md),
          border: widget.secondary
              ? Border.all(
                  color: TohyouColors.surfaceHighlight,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(TohyouRadius.md),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TohyouSpacing.lg,
                vertical: TohyouSpacing.md,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 18,
                      color: foreground,
                    ),
                    const SizedBox(width: TohyouSpacing.sm),
                  ],
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}