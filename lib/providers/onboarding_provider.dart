import 'package:flutter/material.dart';
import '../models/onboarding_step.dart';

class OnboardingProvider with ChangeNotifier {
  final List<OnboardingStep> steps = [
    OnboardingStep(
      stepNumber: '1',
      title: '다음 중 평소 선호하는\n자연경관은?\n(최대 2개 선택)',
      options: {
        '산': 'assets/images/mountain.png',
        '바다': 'assets/images/beach.png',
        '동굴': 'assets/images/cave.png',
      },
    ),
    OnboardingStep(
      stepNumber: '2',
      title: '다음 중 환경 정화가 필요하다고\n생각하는 장소는?\n(최대 2개 선택)',
      options: {
        '강/하천': 'assets/images/river.png',
        '산책로': 'assets/images/path.png',
        '계곡/폭포': 'assets/images/waterfall.png',
      },
    ),
    OnboardingStep(
      stepNumber: '3',
      title: '다음 중 플로깅을 하면서\n 함께 즐기고 싶은 활동은?\n(최대 2개 선택)',
      options: {
        '유적지': 'assets/images/historic.png',
        '특이 지형': 'assets/images/unique.png',
        '이색 체험': 'assets/images/experience.png',
      },
    ),
  ];

  final List<List<String>> selected = [];

  OnboardingProvider() {
    selected.addAll(List.generate(steps.length, (_) => []));
  }

  void toggleSelect(int stepIndex, String option) {
    if (selected[stepIndex].contains(option)) {
      selected[stepIndex].remove(option);
    } else if (selected[stepIndex].length < 2) {
      selected[stepIndex].add(option);
    }
    notifyListeners();
  }

  void submit() {
    debugPrint(selected.toString());
  }
}