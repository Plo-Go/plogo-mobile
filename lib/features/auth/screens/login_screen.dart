import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_info_provider.dart';
import 'package:plogo/features/home/services/recommend_service.dart';
import '../providers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // 카카오 웹뷰 로그인
  Future<void> _loginWithKakao() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // 1. 카카오 로그인 (웹뷰)
      OAuthToken kakaoToken = await UserApi.instance.loginWithKakaoAccount();
      print('카카오 로그인 성공 - 토큰: ${kakaoToken.accessToken}');

      // 2. 사용자 정보 가져오기 (선택사항, 디버깅용)
      User user = await UserApi.instance.me();
      print('사용자 정보: ${user.kakaoAccount?.profile?.nickname}');

      // 3. 백엔드에 카카오 액세스 토큰 전송 및 JWT 토큰 받기
      final loginResponse =
          await _authService.kakaoMobileLogin(kakaoToken.accessToken);

      if (loginResponse.isSuccess && loginResponse.data != null) {
        // 4. JWT 토큰 저장
        await TokenStorage.saveTokens(
          accessToken: loginResponse.data!.accessToken,
          refreshToken: loginResponse.data!.refreshToken,
        );
        print('JWT 토큰 저장 완료');

        // 로그인 성공 시 인증 상태 Provider true로 변경
        ref.read(authProvider.notifier).login();
        print('[로그인] isLoggedInProvider: ${ref.read(isLoggedInProvider)}');
        // authProvider 상태도 출력 (있으면)
        try {
          final authState = ref.read(authProvider);
          print('[로그인] authProvider.state.isLoggedIn: ${authState.isLoggedIn}');
        } catch (e) {
          print('[로그인] authProvider 상태 읽기 실패: $e');
        }

        // 5. JWT 토큰으로 유저 정보 조회
        try {
          final userInfoResponse = await _authService.getUserInfo();
          if (userInfoResponse.isSuccess && userInfoResponse.data != null) {
            final userInfo = UserInfo.fromJson(userInfoResponse.data!);
            ref.read(userInfoProvider.notifier).state = userInfo;
            print('유저 정보 저장 완료: ${userInfo.nickname}');
          }
        } catch (e) {
          print('유저 정보 조회 실패: $e');
        }

        // 6. 추천 코스 조회 후 온보딩/홈 분기
        try {
          final recommendService = RecommendService();
          final recommendResponse =
              await recommendService.getRecommendedCourses();
          print(
              '[추천코스 API] isSuccess: ���[32m${recommendResponse.isSuccess}���[0m');
          print('[추천코스 API] code: ${recommendResponse.code}');
          print('[추천코스 API] message: ${recommendResponse.message}');
          print(
              '[추천코스 API] data.length: ���[36m${recommendResponse.data.length}���[0m');
          print('[추천코스 API] data: ${recommendResponse.data}');
          if (recommendResponse.isSuccess &&
              recommendResponse.data.isNotEmpty) {
            print('[분기] 홈으로 이동');
            if (mounted) context.go('/home');
          } else {
            print('[분기] 온보딩으로 이동');
            if (mounted) context.go('/onboarding');
          }
        } catch (e) {
          print('[추천코스 API] 예외 발생: $e');
          print('[분기] 온보딩으로 이동');
          if (mounted) context.go('/onboarding');
        }
      } else {
        throw Exception(loginResponse.message);
      }
    } catch (error) {
      print('로그인 실패: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패했습니다. 다시 시도해주세요.\n$error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 브랜드 타이틀과 서브타이틀
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/plogo.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8),
                    const Text(
                      '국내 플로깅 코스 추천 서비스',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 카카오 로그인 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithKakao,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFEE500),
                    foregroundColor: AppColors.black,
                    disabledBackgroundColor:
                        const Color(0xFFFEE500).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.black),
                          ),
                        )
                      : const Text(
                          '카카오 계정으로 로그인하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
