import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/course_models.dart';

/// 추천 코스 관련 API 서비스
class RecommendService {
  final Dio _dio = apiClient.dio;

  /// 추천 코스 조회
  Future<CourseRecommendResponse> getRecommendedCourses() async {
    try {
      final response = await _dio.get('/course/recommend');
      return CourseRecommendResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('추천 코스 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('추천 코스 조회 실패: $e');
    }
  }
}
