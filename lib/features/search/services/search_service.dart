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
}
