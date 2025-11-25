import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/main.dart';

class SearchApiService {
  final Dio _dio;
  SearchApiService(this._dio);

  /// 지역별 코스 리스트 불러오기
  Future<List<Map<String, dynamic>>> getCoursesByArea(int areaCode) async {
    final response = await _dio.get('/course/area/$areaCode');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  /// 코스 검색
  Future<List<Map<String, dynamic>>> searchCourses(String keyword) async {
    try {
      final response = await _dio.get('/search/course/$keyword');
      if (response.data != null && response.data['isSuccess'] == true) {
        final data = response.data['data'] as List<dynamic>?;
        if (data != null) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        // 인증 오류 발생 시 로그인 페이지로 이동
        final context = rootNavigatorKey.currentContext;
        if (context != null) {
          GoRouter.of(context).go('/login');
        }
      }
      rethrow;
    }
  }

  /// 시군구 코드 불러오기
  Future<List<Map<String, dynamic>>> getSigunguList() async {
    final response = await _dio.get('/search/sigungu_code');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }
}
