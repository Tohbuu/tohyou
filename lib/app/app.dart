import 'package:flutter/material.dart';

import 'app_router.dart';

class TohyouApp extends StatelessWidget {
  const TohyouApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TOHYOU',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}