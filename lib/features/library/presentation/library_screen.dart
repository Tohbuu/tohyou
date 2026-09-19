import 'package:flutter/material.dart';

import '../../../core/design/components/tohyou_placeholder_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TohyouPlaceholderScreen(
      title: 'Library',
      icon: Icons.library_books_outlined,
      description: 'Your anime and manga collections will live here.',
    );
  }
}