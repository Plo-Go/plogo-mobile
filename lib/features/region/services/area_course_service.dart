import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../home/models/course_models.dart';

/// 지역별 코스 API 서비스
class AreaCourseService {
  final Dio _dio = apiClient.dio;

  /// 특정 지역(areaCode) 코스 조회
  Future<CourseRecommendResponse> getCoursesByArea(int areaCode) async {
    try {
      final response = await _dio.get('/course/area/$areaCode');
      return CourseRecommendResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('지역 코스 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('지역 코스 조회 실패: $e');
    }
  }
}
