import 'package:plogo/main.dart';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';
import '../../features/auth/services/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/user_info_provider.dart';
import 'package:plogo/features/auth/providers/auth_controller.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      await TokenStorage.clearTokens();
      AuthController.instance.logout();
    }
    final error = _handleError(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: error,
      response: err.response,
    ));
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
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