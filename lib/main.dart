import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'core/router/app_router.dart';
import 'core/api/api_client.dart';
import 'shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 플러그인 초기화용

  // 환경 변수 로드
  await dotenv.load(fileName: '.env');

  // 카카오 로그인 SDK 초기화 (네이티브 앱 키)
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '',
  );

  // 카카오맵 SDK 초기화 (JavaScript 키)
  AuthRepository.initialize(
    appKey: dotenv.env['KAKAO_JS_KEY'] ?? '',
  );

  // API 클라이언트 초기화
  apiClient.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PloGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
