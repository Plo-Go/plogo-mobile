import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plogo/shared/widgets/loading_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 예시: 닉네임 Provider (실제 프로젝트에 맞게 수정 필요)
final nicknameProvider = Provider<String>((ref) => '닉네임');

class OnboardingCompleteScreen extends ConsumerStatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  ConsumerState<OnboardingCompleteScreen> createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends ConsumerState<OnboardingCompleteScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final nickname = ref.watch(nicknameProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 238, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading) ...[
              Text(
                '$nickname님께서 좋아하실 만한\n플로깅 코스를 찾고 있어요.',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 88),
              const Center(
                child: LineSpinner(
                  size: 60,
                  lineCount: 16,
                  lineLength: 8,
                  lineWidth: 5,
                  duration: Duration(milliseconds: 1600),
                ),
              ),
            ] else ...[
              const Text(
                '선택하신 테마를 바탕으로\n플로깅 코스를 추천해드릴게요.',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 88),
              Center(
                child: Image.asset(
                  'assets/images/completed.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        context.go('/home');
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor:
                      isLoading ? AppColors.grey : AppColors.primary,
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
