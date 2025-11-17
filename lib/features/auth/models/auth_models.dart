// API 공통 응답 모델
class ApiResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final Map<String, dynamic>? data;

  ApiResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
/// 카카오 모바일 로그인 요청 모델
class KakaoMobileLoginRequest {
  final String accessToken;

  KakaoMobileLoginRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
      };
}

/// 로그인 결과 응답 모델
class LoginResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

/// 로그인 데이터 (토큰)
class LoginData {
  final String accessToken;
  final String refreshToken;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
