/// 앱 전역 설정
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 앱 전역 설정
class AppConfig {
  /// API Base URL
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  /// 앱 버전
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '';
}

