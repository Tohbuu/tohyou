import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_motion.dart';
import '../app_radius.dart';
import '../app_spacing.dart';

class TohyouIconButton extends StatefulWidget {
  const TohyouIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.selected = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool selected;

  @override
  State<TohyouIconButton> createState() => _TohyouIconButtonState();
}

class _TohyouIconButtonState extends State<TohyouIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: TohyouMotion.fast,
        decoration: BoxDecoration(
          color: widget.selected || _hovered
              ? TohyouColors.surfaceHighlight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TohyouRadius.md),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(TohyouRadius.md),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.all(TohyouSpacing.md),
              child: Icon(
                widget.icon,
                color: widget.selected
                    ? TohyouColors.accent
                    : TohyouColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip == null) {
      return button;
    }

    return Tooltip(
      message: widget.tooltip!,
      child: button,
    );
  }
}