import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/showcase/presentation/showcase_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/showcase',
      builder: (context, state) {
        return const ShowcaseScreen();
      },
    ),
  ],
);