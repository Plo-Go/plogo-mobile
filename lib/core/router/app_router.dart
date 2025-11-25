import 'package:plogo/features/mypage/screens/saved_courses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/features/region/screens/region_list.dart';
import 'package:plogo/layout/main_layout.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_complete_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/log/screens/log_screen.dart';
import '../../features/mypage/screens/mypage_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/detail/screens/course_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/user_info_provider.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final isLoggedIn = container.read(isLoggedInProvider);
    final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/splash';

    print('==============================');
    print('[GoRouter redirect] 경로: ${state.matchedLocation}');
    print('[GoRouter redirect] isLoggedIn: $isLoggedIn');
    print('[GoRouter redirect] loggingIn: $loggingIn');
    print('==============================');

    // /login 경로에서만 인증 상태가 true면 홈으로 이동
    if (state.matchedLocation == '/login' && isLoggedIn) {
      print('[GoRouter redirect] 이미 로그인됨 → /home 이동');
      return '/home';
    }

    // 인증 상태가 false인데 로그인/스플래시가 아니면 로그인으로 이동
    if (!isLoggedIn && !loggingIn) {
      print('[GoRouter redirect] 로그인 필요 → /login 이동');
      return '/login';
    }

    // 인증 상태가 true면 /login으로 이동하지 않음
    return null;
  },
  routes: [
    // 스플래시 (하단바 없음)
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // 로그인 (하단바 없음)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // 온보딩 (하단바 없음)
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/onboarding-complete',
      builder: (context, state) => const OnboardingCompleteScreen(),
    ),

    // 앱 메인 탭 (하단바 적용)
    ShellRoute(
      builder: (context, state, child) {
        // 현재 탭 인덱스 계산
        final loc = state.matchedLocation;
        int index = 0;
        if (loc.startsWith('/log')) {
          index = 1;
        } else if (loc.startsWith('/mypage')) {
          index = 2;
        } else {
          index = 0; // 기본 홈
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
            final title = state.extra is String ? state.extra as String : null;
            return CourseDetailScreen(courseId: courseId, title: title);
          },
        ),
        GoRoute(
          path: '/log/detail/:courseId',
          builder: (context, state) {
            final courseId =
                int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
            final title = state.extra is String ? state.extra as String : null;
            return CourseDetailScreen(courseId: courseId, title: title);
          },
        ),
        GoRoute(
          path: '/mypage/detail/:courseId',
          builder: (context, state) {
            final courseId =
                int.tryParse(state.pathParameters['courseId'] ?? '0') ?? 0;
            final title = state.extra is String ? state.extra as String : null;
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
            return RegionListScreen(regionName: regionName, areaCode: areaCode);
          },
        ),
      ],
    ),
  ],
);
