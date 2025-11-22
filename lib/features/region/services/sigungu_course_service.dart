import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../home/models/course_models.dart';

class SigunguCourseService {
  final Dio _dio = apiClient.dio;

  Future<CourseRecommendResponse> getCoursesBySigungu(int sigunguId) async {
    try {
      final response = await _dio.get('/course/sigungu/$sigunguId');
      return CourseRecommendResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('시군구 코스 조회 실패: $e');
    }
  }
}
