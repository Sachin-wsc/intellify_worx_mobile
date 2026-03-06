import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/industry_screen.dart';
import '../ui/screens/drive_selection_screen.dart';
import '../ui/screens/product_screen.dart';
import '../ui/screens/tech_support_screen.dart';
import '../ui/screens/commissioning_support_screen.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: authProvider.isAuthenticated ? '/' : '/login',
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isAuthenticated && !isGoingToLogin) {
        return '/login';
      }
      if (isAuthenticated && isGoingToLogin) {
        return '/';
      }
      return null;
    },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/industry',
      builder: (context, state) => const IndustryScreen(),
    ),
    GoRoute(
      path: '/drive_selection',
      builder: (context, state) => const DriveSelectionScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/tech_support',
      builder: (context, state) => const TechSupportScreen(),
    ),
    GoRoute(
      path: '/commissioning',
      builder: (context, state) => const CommissioningSupportScreen(),
    ),
    ],
  );
}
