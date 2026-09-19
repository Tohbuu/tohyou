import 'package:flutter/material.dart';

import '../../../core/design/components/tohyou_placeholder_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TohyouPlaceholderScreen(
      title: 'Search',
      icon: Icons.search,
      description: 'Search anime and manga across your available sources.',
    );
  }
}