import 'package:flutter/material.dart';
import 'package:plogo/main.dart';
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
  void logout() {
    print('[AuthController] 로그아웃 호출');
    state = state.copyWith(isLoggedIn: false);
    print('[AuthController] isLoggedIn: ${state.isLoggedIn}');
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).go('/login');
    }
  }
}

final authProvider =
    AutoDisposeNotifierProvider<AuthController, AuthState>(AuthController.new);
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.select((s) => s.isLoggedIn));
});
