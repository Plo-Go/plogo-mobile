import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class GeocodingService {
  final Dio _dio = Dio();

  Future<LatLng?> getLatLngFromAddress(String address) async {
    final apiKey = dotenv.env['KAKAO_REST_API_KEY'];
    if (apiKey == null || address.isEmpty) return null;
    try {
      final response = await _dio.get(
        'https://dapi.kakao.com/v2/local/search/address.json',
        queryParameters: {'query': address},
        options: Options(headers: {'Authorization': 'KakaoAK $apiKey'}),
      );
      final docs = response.data['documents'] as List?;
      if (docs != null && docs.isNotEmpty) {
        final first = docs.first;
        final lat = double.tryParse(first['y'].toString());
        final lng = double.tryParse(first['x'].toString());
        if (lat != null && lng != null) {
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      print('[Geocoding] 에러: $e');
    }
    return null;
  }
}
