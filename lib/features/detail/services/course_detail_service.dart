import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/course_detail_model.dart';

class CourseDetailService {
  final Dio _dio = apiClient.dio;

  Future<CourseDetailResponse> getCourseDetail(int courseId) async {
    try {
      final response = await _dio.get('/course/detail/$courseId');
      final detailResponse = CourseDetailResponse.fromJson(response.data);
      final detail = detailResponse.data;
      print('[CourseDetail] courseId: [32m${detail.courseId}[0m');
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
}
