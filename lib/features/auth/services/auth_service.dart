import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/auth_models.dart';

/// 인증 관련 API 서비스
class AuthService {
  /// 유저 정보 조회
  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await _dio.get('/user/info');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('유저 정보 조회 실패: ${e.message}');
      throw Exception('유저 정보 조회 실패: ${e.message}');
    } catch (e) {
      print('유저 정보 조회 실패: $e');
      throw Exception('유저 정보 조회 실패: $e');
    }
  }

  final Dio _dio = apiClient.dio;

  /// 카카오 모바일 로그인
  Future<LoginResponse> kakaoMobileLogin(String kakaoAccessToken) async {
    try {
      final response = await _dio.post(
        '/user/kakao/login/app',
        queryParameters: {
          'accessToken': kakaoAccessToken,
        },
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('카카오 로그인 실패: ${e.message}');
      throw Exception('카카오 로그인 실패: ${e.message}');
    } catch (e) {
      print('카카오 로그인 실패: $e');
      throw Exception('카카오 로그인 실패: $e');
    }
  }
}
