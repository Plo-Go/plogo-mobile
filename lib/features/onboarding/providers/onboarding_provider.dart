import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/models/onboarding_step.dart';

class OnboardingNotifier extends Notifier<List<List<String>>> {
  static final List<OnboardingStep> steps = [
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

  @override
  List<List<String>> build() {
    return List.generate(steps.length, (_) => []);
  }

  void toggleSelect(int stepIndex, String option) {
    final current = state;
    final newState = current.map((list) => List<String>.from(list)).toList();
    if (newState[stepIndex].contains(option)) {
      newState[stepIndex].remove(option);
    } else if (newState[stepIndex].length < 2) {
      newState[stepIndex].add(option);
    }
    state = newState;
  }

  Future<bool> submit(Dio dio) async {
    final body = toApiRequestBody();
    try {
      final response = await dio.post('/course/analyze', data: body);
      final isSuccess = response.data['isSuccess'] == true;
      debugPrint('[선호도 저장 API] 응답: ${response.data}');
      debugPrint('[선호도 저장 API] isSuccess: $isSuccess');
      debugPrint('[선호도 저장 API] code: ${response.data['code']}');
      debugPrint('[선호도 저장 API] message: ${response.data['message']}');
      return isSuccess;
    } catch (e) {
      debugPrint('[선호도 저장 API] 오류: $e');
      return false;
    }
  }

    Map<String, List<String>> toApiRequestBody() {
      return {
        "firstKeyword": state[0],
        "secondKeyword": state[1],
        "thirdKeyword": state[2],
      };
    }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, List<List<String>>>(
  OnboardingNotifier.new,
);

