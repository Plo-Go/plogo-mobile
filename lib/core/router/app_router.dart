import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/main.dart';
import 'package:plogo/features/auth/providers/auth_controller.dart';
import 'package:plogo/features/onboarding/screens/onboarding_screen.dart';
import 'package:plogo/features/onboarding/screens/splash_screen.dart';
import 'package:plogo/features/onboarding/screens/onboarding_complete_screen.dart';
import 'package:plogo/features/home/screens/home_screen.dart';
import 'package:plogo/features/log/screens/log_screen.dart';
import 'package:plogo/features/mypage/screens/mypage_screen.dart';
import 'package:plogo/features/search/screens/search_screen.dart';
import 'package:plogo/features/auth/screens/login_screen.dart';
import 'package:plogo/features/detail/screens/course_detail_screen.dart';
import 'package:plogo/features/mypage/screens/saved_courses_list_screen.dart';
import 'package:plogo/features/region/screens/region_list.dart';
import 'package:plogo/layout/main_layout.dart';

class GoRouterAuthNotifier extends ChangeNotifier {
  GoRouterAuthNotifier(this.ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}

final goRouterNotifierProvider =
    ChangeNotifierProvider<GoRouterAuthNotifier>((ref) {
  return GoRouterAuthNotifier(ref);
});

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: ref.watch(goRouterNotifierProvider),
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final isLoggedIn = container.read(isLoggedInProvider);
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/splash';

      if (state.matchedLocation == '/login' && isLoggedIn) {
        return '/home';
      }
      if (!isLoggedIn && !loggingIn) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding-complete',
        builder: (context, state) => const OnboardingCompleteScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          final loc = state.matchedLocation;
          int index = 0;
          if (loc.startsWith('/log')) {
            index = 1;
          } else if (loc.startsWith('/mypage')) {
            index = 2;
          } else {
            index = 0;
          }
          return MainLayout(
            child: child,
            currentIndex: index,
            onTap: (i) {
              switch (i) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/log');
                  break;
                case 2:
                  context.go('/mypage');
                  break;
              }
            },
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/log',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LogScreen()),
          ),
          GoRoute(
            path: '/mypage',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyPageScreen()),
          ),
          GoRoute(
            path: '/mypage/saved-courses',
            builder: (context, state) => const SavedCoursesListScreen(),
          ),
          GoRoute(
            path: '/home/detail/:courseId',
            builder: (context, state) {
              final courseId =
                  int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
              final title =
                  state.extra is String ? state.extra as String : null;
              return CourseDetailScreen(courseId: courseId, title: title);
            },
          ),
          GoRoute(
            path: '/log/detail/:courseId',
            builder: (context, state) {
              final courseId =
                  int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
              final title =
                  state.extra is String ? state.extra as String : null;
              return CourseDetailScreen(courseId: courseId, title: title);
            },
          ),
          GoRoute(
            path: '/mypage/detail/:courseId',
            builder: (context, state) {
              final courseId =
                  int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
              final title =
                  state.extra is String ? state.extra as String : null;
              return CourseDetailScreen(courseId: courseId, title: title);
            },
          ),
          GoRoute(
            path: '/region/:areaCode',
            builder: (context, state) {
              final areaCode =
                  int.tryParse(state.pathParameters['areaCode'] ?? '0') ?? 0;
              final regionName =
                  state.extra is String ? state.extra as String : '';
              return RegionListScreen(
                  regionName: regionName, areaCode: areaCode);
            },
          ),
        ],
      ),
    ],
  );
});
