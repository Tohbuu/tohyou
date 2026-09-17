import 'package:flutter/material.dart';

import '../core/design/app_theme.dart';
import 'app_router.dart';

class TohyouApp extends StatelessWidget {
  const TohyouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TOHYOU',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: TohyouTheme.dark(),
    );
  }
}