import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/course_detail_model.dart';

class CourseDetailService {
  final Dio _dio = apiClient.dio;

  Future<CourseDetailResponse> getCourseDetail(int courseId) async {
    try {
      final response = await _dio.get('/course/detail/$courseId');
      return CourseDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('코스 상세 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('코스 상세 조회 실패: $e');
    }
  }
}
