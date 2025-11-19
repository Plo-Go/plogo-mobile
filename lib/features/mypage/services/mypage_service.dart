import 'package:dio/dio.dart';
import 'package:plogo/features/auth/services/token_storage.dart';
import 'package:plogo/features/auth/models/auth_models.dart';

/// 마이페이지 관련 API 서비스
class MyPageService {
  Future<List<Map<String, dynamic>>> getRecentCourses() async {
    print('[최근 확인한 코스 API 요청] /course/recent');
    final response = await _dio.get('/course/recent');
    print('[최근 확인한 코스 API 응답] ${response.data}');
    return List<Map<String, dynamic>>.from(response.data['data'] ?? []);
  }
  final Dio _dio;
  MyPageService(this._dio);

  /// 저장한 코스 목록 조회
  Future<List<Map<String, dynamic>>> getSavedCourses() async {
    try {
      final response = await _dio.get('/course/save_list');
      print('[SavedCourses] 응답: ${response.data}');
      if (response.data != null &&
          response.data['isSuccess'] == true &&
          response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } catch (e) {
      print('[SavedCourses] 에러: $e');
      return [];
    }
  }

  /// 회원탈퇴(로그아웃) API 호출
  Future<ApiResponse> withdraw() async {
    final accessToken = await TokenStorage.getAccessToken();
    try {
      final response = await _dio.delete(
        '/user/withdraw',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
