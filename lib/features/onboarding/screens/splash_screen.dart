import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/features/auth/services/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 1.5초 후 토큰 조회 및 분기
    Timer(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      final accessToken = await TokenStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        // 로그인 상태: 홈으로 이동
        context.go('/home');
      } else {
        // 비로그인: 로그인 화면으로 이동
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 중앙 로고
            Center(
              child: Image.asset(
                'assets/images/mainlogo.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),
            // 하단 앱 이름
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: Text(
                'PloGo',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
