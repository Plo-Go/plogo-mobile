import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/theme/app_colors.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,  // 뒤로가기 없애기
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 90),
            const Text(
              '선택하신 테마를 바탕으로\n플로깅 코스를 추천해드릴게요.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 90),
            const Center(
              child: Image(
                image: AssetImage('assets/images/completed.png'),
                width: 80,  // 원하는 크기
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: AppColors.primary,
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}