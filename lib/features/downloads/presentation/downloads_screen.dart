import 'package:flutter/material.dart';

import '../../../core/design/components/tohyou_placeholder_screen.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TohyouPlaceholderScreen(
      title: 'Downloads',
      icon: Icons.download_outlined,
      description: 'Offline anime and manga downloads will appear here.',
    );
  }
}