import 'package:dio/dio.dart';

class SearchService {
  final Dio _dio;
  SearchService(this._dio);

  /// 최근 검색어 불러오기
  Future<List<String>> getRecentKeywords() async {
    final response = await _dio.get('/search/recent');
    if (response.data != null && response.data['isSuccess'] == true) {
      final data = response.data['data'] as List<dynamic>?;
      if (data != null) {
        return data.map((e) => e['keyword'] as String).toList();
      }
    }
    return [];
  }

  /// 최근 검색어 삭제
  Future<bool> deleteKeyword(String keyword) async {
    try {
      print('[deleteKeyword] PATCH /search/delete/$keyword');
      final response = await _dio.patch('/search/delete/$keyword');
      print('[deleteKeyword] response: ${response.data}');
      if (response.data != null && response.data['isSuccess'] == true) {
        return true;
      }
    } catch (e) {
      print('검색어 삭제 실패: $e');
    }
    return false;
  }
}
