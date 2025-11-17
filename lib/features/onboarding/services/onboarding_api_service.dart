import 'package:dio/dio.dart';
import '../providers/onboarding_provider.dart';

class OnboardingApiService {
  final Dio _dio;
  OnboardingApiService(this._dio);

  Future<Response> analyzeCourse(Map<String, List<String>> body) async {
    return await _dio.post('/course/analyze', data: body);
  }
}
