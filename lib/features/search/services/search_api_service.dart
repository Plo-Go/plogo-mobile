import 'package:dio/dio.dart';

class SearchApiService {
  ///지역별 코스 리스트 불러오기
  Future<List<Map<String, dynamic>>> getCoursesByArea(int areaCode) async {
    final response = await _dio.get('/course/area/$areaCode');
    print('[getCoursesByArea] areaCode: $areaCode, response: ${response.data}');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }
  final Dio _dio;
  SearchApiService(this._dio);

  ///코스 검색
  Future<List<Map<String, dynamic>>> searchCourses(String keyword) async {
    final response = await _dio.get('/search/course/$keyword');
    print('[searchCourses] keyword: $keyword, response: ${response.data}');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  ///시군구 코드 불러오기
  Future<List<Map<String, dynamic>>> getSigunguList() async {
    final response = await _dio.get('/search/sigungu_code');
    print('[getSigunguList] response: ${response.data}');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }
}
