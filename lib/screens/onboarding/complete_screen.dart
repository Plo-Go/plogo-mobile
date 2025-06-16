import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plogo/providers/onboarding_provider.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('온보딩 완료')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('선호도가 저장되었습니다!', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text('자연환경: ${provider.nature.join(', ')}'),
            Text('정책: ${provider.policy.join(', ')}'),
            Text('활동: ${provider.activity.join(', ')}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                provider.reset();
              },
              child: const Text('다시 시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}