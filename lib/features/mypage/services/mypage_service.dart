import 'package:dio/dio.dart';
import 'package:plogo/features/auth/services/token_storage.dart';
import 'package:plogo/features/auth/models/auth_models.dart';

/// 마이페이지 관련 API 서비스
class MyPageService {
  final Dio _dio;
  MyPageService(this._dio);

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
