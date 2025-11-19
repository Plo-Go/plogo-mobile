import 'package:dio/dio.dart';
import 'api_interceptor.dart';
import '../config/app_config.dart';

/// Dio 클라이언트 설정
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final Dio _dio;

  Dio get dio => _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 인터셉터 추가
    _dio.interceptors.add(ApiInterceptor());
  }
}

/// 전역 API 클라이언트 인스턴스
final apiClient = ApiClient();
