import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfo {
  final int kakaoId;
  final String nickname;
  final String profileImg;
  final String level;
  final int stampCount;

  UserInfo({
    required this.kakaoId,
    required this.nickname,
    required this.profileImg,
    required this.level,
    required this.stampCount,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      kakaoId: json['kakaoId'] ?? 0,
      nickname: json['nickname'] ?? '',
      profileImg: json['profileImg'] ?? '',
      level: json['level'] ?? '',
      stampCount: json['stampCount'] ?? 0,
    );
  }
}

final userInfoProvider = StateProvider<UserInfo?>((ref) => null);

/// 인증 상태 Provider (로그인 여부)
final isLoggedInProvider = StateProvider<bool>((ref) => false);
