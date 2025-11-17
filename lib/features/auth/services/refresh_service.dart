import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import 'token_storage.dart';

/// 리프레시 토큰으로 액세스 토큰 재발급 (API 없어서 되는지 모르겠음 - 임시로 구현)
class RefreshService {
  final Dio _dio = apiClient.dio;

  /// refreshToken으로 accessToken 재발급
  Future<String?> refreshAccessToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final response = await _dio.post('/user/refresh', data: {
        'refreshToken': refreshToken,
      });
      final newAccessToken = response.data['accessToken'] as String?;
      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await TokenStorage.saveAccessToken(newAccessToken);
        return newAccessToken;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
