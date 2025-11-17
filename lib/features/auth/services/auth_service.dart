import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../models/auth_models.dart';

/// 인증 관련 API 서비스
class AuthService {
  /// 유저 정보 조회
  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await _dio.get('/user/info');
      print('유저 정보 응답: ${response.data}');
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('유저 정보 DioException: ${e.message}');
      throw Exception('유저 정보 조회 실패: ${e.message}');
    } catch (e) {
      print('유저 정보 알 수 없는 에러: $e');
      throw Exception('유저 정보 조회 실패: $e');
    }
  }
  final Dio _dio = apiClient.dio;

  /// 카카오 모바일 로그인
  Future<LoginResponse> kakaoMobileLogin(String kakaoAccessToken) async {
    try {
      print('백엔드 API 호출 시작: /user/kakao/login/app');
      print('카카오 토큰: ${kakaoAccessToken.substring(0, 20)}...');

      // Query 파라미터로 accessToken 전송
      final response = await _dio.post(
        '/user/kakao/login/app',
        queryParameters: {
          'accessToken': kakaoAccessToken,
        },
      );

      print('백엔드 응답 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');

      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('DioException 발생!');
      print('에러 타입: ${e.type}');
      print('상태 코드: ${e.response?.statusCode}');
      print('에러 메시지: ${e.message}');
      print('응답 데이터: ${e.response?.data}');
      throw Exception('카카오 로그인 실패: ${e.message}');
    } catch (e) {
      print('알 수 없는 에러: $e');
      throw Exception('카카오 로그인 실패: $e');
    }
  }
}
