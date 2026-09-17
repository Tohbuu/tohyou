import 'package:flutter/material.dart';

class TohyouAppShell extends StatelessWidget {
  const TohyouAppShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}