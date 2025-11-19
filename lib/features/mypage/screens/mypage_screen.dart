import 'package:flutter/material.dart';
import 'package:plogo/features/mypage/widgets/profile_header.dart';
import 'package:plogo/features/mypage/widgets/saved_courses_section.dart';
import 'package:plogo/features/search/widgets/recent_viewed_courses_section.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/auth/services/token_storage.dart';
import 'package:plogo/features/auth/services/auth_service.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:go_router/go_router.dart';


class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  Map<String, dynamic>? userInfo;
  List<Map<String, dynamic>> savedCourses = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _fetchSavedCourses();
  }

  Future<void> _fetchUserInfo() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final response = await AuthService().getUserInfo();
      print('[유저 정보] ${response.data}');
      setState(() {
        userInfo = response.data as Map<String, dynamic>?;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = '유저 정보 불러오기 실패';
        loading = false;
      });
    }
  }

  Future<void> _fetchSavedCourses() async {
    try {
      final service = MyPageService(apiClient.dio);
      final items = await service.getSavedCourses();
      setState(() {
        savedCourses = items;
      });
    } catch (e) {
      print('[저장 코스 목록 에러] $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 저장 코스 목록 (API 연동)

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          // 상단 프로필 영역
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            Center(child: Text(error!))
          else if (userInfo != null)
            ProfileHeader(
              nickname: userInfo!['nickname'] ?? '닉네임',
              level: int.tryParse(userInfo!['level'] ?? '1') ?? 1,
              levelLabel: userInfo!['level'] ?? '새싹 플로거',
              profileImg: userInfo!['profileImg'] ?? '',
              stampCount: userInfo!['stampCount'] ?? 0,
            )
          else
            const ProfileHeader(
              nickname: '닉네임',
              level: 1,
              levelLabel: '새싹 플로거',
              stampCount: 0,
            ),
          const SizedBox(height: 36),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 8,
            color: AppColors.greyLight,
          ),
          const SizedBox(height: 16),

          // 저장 목록 섹션
          SavedCoursesSection(
            items: savedCourses,
            onSeeAll: () {},
          ),
          const SizedBox(height: 32),

          // 최근 확인한 코스 섹션 (검색 화면의 섹션 재사용)
          const RecentViewedCoursesSection(
            items: [], // 빈 리스트로 테스트, 추후 실제 데이터 연동
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 8,
            color: AppColors.greyLight,
          ),
          const SizedBox(height: 8),

          // 설정 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListTileTheme(
              data: const ListTileThemeData(
                dense: true,
                minVerticalPadding: 0,
                horizontalTitleGap: 0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    title: const Text(
                      '선호도 재설정',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      // TODO: 온보딩 선호도 질문으로 이동
                    },
                  ),
                  const SizedBox(height: 6),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    visualDensity:
                        const VisualDensity(horizontal: -2, vertical: -4),
                    title: const Text(
                      '회원탈퇴',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey),
                    ),
                    onTap: () async {
                      // 회원탈퇴 API 호출
                      final service = MyPageService(apiClient.dio);
                      try {
                        final response = await service.withdraw();
                        print(
                            '[회원탈퇴] 성공: ${response.isSuccess}, code: ${response.code}, message: ${response.message}');
                      } catch (e) {
                        print('[회원탈퇴] 실패: $e');
                      }
                      // 토큰 삭제
                      await TokenStorage.clearTokens();
                      // 스플래시로 이동
                      context.go('/splash');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
