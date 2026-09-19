import 'package:flutter/material.dart';

import '../../../core/design/components/tohyou_placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TohyouPlaceholderScreen(
      title: 'Settings',
      icon: Icons.settings_outlined,
      description: 'Configure TOHYOU and your local environment.',
    );
  }
}