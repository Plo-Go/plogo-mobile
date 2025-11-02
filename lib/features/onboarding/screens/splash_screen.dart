import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 간단한 지연 후 온보딩으로 이동 (차후 로그인 상태에 따라 분기 가능)
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      // TODO: 로그인 상태에 따라 홈/온보딩 분기
      context.go('/login');
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
                'Plogo',
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
