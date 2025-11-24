import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/course_detail_model.dart';

class CourseDetailService {
  final Dio _dio = apiClient.dio;

  Future<Map<String, dynamic>?> getCoursePosts(int courseId) async {
    try {
      print('[CoursePosts] 요청 courseId: $courseId');
      final response = await _dio.get('/course/post/$courseId');
      print('[CoursePosts] 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('[CoursePosts] 에러: $e');
      return null;
    }
  }

  Future<CourseDetailResponse> getCourseDetail(int courseId) async {
    try {
      final response = await _dio.get('/course/detail/$courseId');
      final detailResponse = CourseDetailResponse.fromJson(response.data);
      final detail = detailResponse.data;
      print('[CourseDetail] courseId: ${detail.courseId}');
      print('[CourseDetail] name: ${detail.name}');
      print('[CourseDetail] image: ${detail.image}');
      print('[CourseDetail] summary: ${detail.summary}');
      print('[CourseDetail] address: ${detail.address}');
      print('[CourseDetail] tel: ${detail.tel}');
      print('[CourseDetail] telName: ${detail.telName}');
      print('[CourseDetail] charge: ${detail.charge}');
      print('[CourseDetail] homepage: ${detail.homepage}');
      print('[CourseDetail] isSave: ${detail.isSave}');
      print('[CourseDetail] isComplete: ${detail.isComplete}');
      return detailResponse;
    } on DioException catch (e) {
      throw Exception('코스 상세 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('코스 상세 조회 실패: $e');
    }
  }

  Future<Map<String, dynamic>?> toggleSaveCourse(int courseId) async {
    try {
      final response = await _dio.post('/course/save/$courseId');
      print('[CourseSave] 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('[CourseSave] 에러: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> completeCourse(int courseId) async {
    try {
      final response = await _dio.post('/course/complete/$courseId');
      print('[CourseComplete] 응답: ${response.data}');
      return response.data;
    } catch (e) {
      print('[CourseComplete] 에러: $e');
      return null;
    }
  }
}
