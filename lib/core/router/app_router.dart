import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/layout/main_layout.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_complete_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/log/screens/log_screen.dart';
import '../../features/mypage/screens/mypage_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/auth/screens/login_screen.dart';

/// 앱 라우터 설정
final appRouter = GoRouter(
  initialLocation: '/splash',
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
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/log',
          pageBuilder: (context, state) => const NoTransitionPage(child: LogScreen()),
        ),
        GoRoute(
          path: '/mypage',
          pageBuilder: (context, state) => const NoTransitionPage(child: MyPageScreen()),
        ),
        // 검색 화면 (하단바 포함)
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    ),
  ],
);

