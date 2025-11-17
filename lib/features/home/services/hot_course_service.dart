import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/course_models.dart';

/// 최근 핫한 코스 관련 API 서비스
class HotCourseService {
  final Dio _dio = apiClient.dio;

  /// 최근 핫한 코스 조회
  Future<CourseRecommendResponse> getHotCourses() async {
    try {
      final response = await _dio.get('/course/hot');
      return CourseRecommendResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('핫한 코스 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('핫한 코스 조회 실패: $e');
    }
  }
}
