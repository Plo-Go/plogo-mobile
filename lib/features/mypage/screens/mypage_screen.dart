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
import 'package:plogo/features/log/services/log_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/auth/providers/auth_controller.dart'; // ← 추가
import 'package:plogo/features/mypage/widgets/confirm_withdraw_dialog.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  Map<String, dynamic>? userInfo;
  List<Map<String, dynamic>> savedCourses = [];
  List<Map<String, dynamic>> recentCourses = [];
  int completedCourseCount = 0;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() => loading = true);
    await Future.wait([
      _fetchUserInfo(),
      _fetchSavedCourses(),
      _fetchRecentCourses(),
      _fetchCompletedCourseCount(),
    ]);
    setState(() => loading = false);
  }

  Future<void> _fetchRecentCourses() async {
    try {
      final service = MyPageService(apiClient.dio);
      final items = await service.getRecentCourses();
      setState(() => recentCourses = items);
    } catch (e) {
      print('[최근 확인한 코스 에러] $e');
    }
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await AuthService().getUserInfo();
      print('[유저 정보] ${response.data}');
      setState(() {
        userInfo = response.data as Map<String, dynamic>?;
        error = null;
      });
    } catch (e) {
      setState(() {
        error = '유저 정보 불러오기 실패';
        userInfo = null;
      });
    }
  }

  Future<void> _fetchSavedCourses() async {
    try {
      final service = MyPageService(apiClient.dio);
      final items = await service.getSavedCourses();
      setState(() => savedCourses = items);
    } catch (e) {
      print('[저장 코스 목록 에러] $e');
    }
  }

  Future<void> _fetchCompletedCourseCount() async {
    try {
      final completedCourses = await LogService().getCompletedCourses();
      setState(() => completedCourseCount = completedCourses.length);
    } catch (e) {
      print('[완주 코스 개수 에러] $e');
      setState(() => completedCourseCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                level: completedCourseCount == 0
                    ? 1
                    : ((completedCourseCount - 1) ~/ 5) + 1,
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
              onSeeAll: _fetchSavedCourses,
              // 카드 클릭 시 새로고침을 위해 콜백 전달
              onCardTap: (courseId, name) async {
                await context.push('/home/detail/$courseId', extra: name);
                _fetchUserInfo();
                _fetchSavedCourses();
                _fetchRecentCourses();
              },
            ),
            const SizedBox(height: 32),

            // 최근 확인한 코스 섹션
            RecentViewedCoursesSection(
              items: recentCourses,
              onRefresh: () async {
                // 카드 클릭 시 새로고침을 위해 콜백 전달
                _fetchRecentCourses();
                _fetchSavedCourses();
              },
              onCardTap: (courseId, name) async {
                await context.push('/home/detail/$courseId', extra: name);
                _fetchUserInfo();
                _fetchSavedCourses();
                _fetchRecentCourses();
              },
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      onTap: () {
                        context.go('/onboarding');
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
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => ConfirmWithdrawDialog(
                            onConfirm: () async {
                              final service = MyPageService(apiClient.dio);
                              try {
                                final response = await service.withdraw();
                                print('[회원탈퇴] 성공: ${response.isSuccess}, code: ${response.code}, message: ${response.message}');
                              } catch (e) {
                                print('[회원탈퇴] 실패: $e');
                              }
                              if (mounted) context.go('/splash');
                            },
                          ),
                        );
                      },
                    ),
                    /* ListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          const VisualDensity(horizontal: -2, vertical: -4),
                      title: const Text(
                        '로그아웃',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey),
                      ),
                      onTap: () async {
                        await TokenStorage.clearTokens();
                        context.go('/login');
                      },
                    ), */
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
