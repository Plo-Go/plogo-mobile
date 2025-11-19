import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/area_code_model.dart';

/// 지역 코드 관련 API 서비스
class AreaCodeService {
  final Dio _dio = apiClient.dio;

  /// 지역 코드 조회
  Future<List<AreaCode>> getAreaCodes() async {
    try {
      final response = await _dio.get('/course/area_code');
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => AreaCode.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('지역 코드 조회 실패: ${e.message}');
    } catch (e) {
      throw Exception('지역 코드 조회 실패: $e');
    }
  }
}
