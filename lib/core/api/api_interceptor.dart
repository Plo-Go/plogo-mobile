import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';

/// API 인터셉터
/// - 요청/응답 로깅
/// - 인증 토큰 추가 (선택사항)
/// - 에러 처리
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 여기에 인증 토큰 추가 등을 구현할 수 있습니다
    // final token = tokenStorage.getToken();
    // options.headers['Authorization'] = 'Bearer $token';
    
    // 디버그용 로깅 (프로덕션에서는 제거하거나 로거 사용)
    if (kDebugMode) {
      // print('REQUEST[${options.method}] => PATH: ${options.path}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      // print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      // print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    
    // DioException을 커스텀 ApiException으로 변환할 수 있습니다
    final error = _handleError(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: error,
      response: err.response,
    ));
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('네트워크 연결 시간이 초과되었습니다.');
      case DioExceptionType.badResponse:
        return ApiException(
          'API 요청 실패: ${error.response?.statusCode}',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return NetworkException('요청이 취소되었습니다.');
      default:
        return NetworkException('네트워크 오류가 발생했습니다.');
    }
  }
}

