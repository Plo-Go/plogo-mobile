import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 브랜드 타이틀과 서브타이틀
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/plogo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8),
                    const Text(
                      '국내 플로깅 코스 추천 서비스',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 카카오 로그인 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 추후 실제 카카오 로그인 연동
                    context.go('/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFEE500), // 카카오 옐로우
                    foregroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '카카오 계정으로 로그인하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
