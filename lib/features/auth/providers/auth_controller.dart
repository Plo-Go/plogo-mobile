import 'package:flutter/material.dart'; // ← 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/features/auth/services/token_storage.dart';

class AuthState {
  final bool isLoggedIn;
  // 필요시 추가 상태 (예: 유저 정보 등)

  AuthState({required this.isLoggedIn});

  AuthState copyWith({bool? isLoggedIn}) =>
      AuthState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);

  factory AuthState.initial() => AuthState(isLoggedIn: false);
}

class AuthController extends AutoDisposeNotifier<AuthState> {
  static late AuthController instance;

  @override
  AuthState build() {
    instance = this;
    // 동기적으로는 false로 초기화
    _checkToken();
    return AuthState(isLoggedIn: false);
  }

  Future<void> _checkToken() async {
    final hasToken = await TokenStorage.isLoggedIn();
    if (hasToken) {
      state = state.copyWith(isLoggedIn: true);
    }
  }

  void login() => state = state.copyWith(isLoggedIn: true);
  void logout() => state = state.copyWith(isLoggedIn: false);
}

final authProvider = AutoDisposeNotifierProvider<AuthController, AuthState>(AuthController.new);

// 예시: 로그인 성공 후 온보딩 이동
void onLoginSuccess(BuildContext context) {
  // context가 라우팅 트리 내에 있는지 확인 후 이동
  GoRouter.of(context).go('/onboarding');
}

// 로그아웃(토큰 만료) 테스트용 함수
void simulateTokenExpired(WidgetRef ref) {
  ref.read(authProvider.notifier).logout();
}