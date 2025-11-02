import 'package:flutter/material.dart';
import 'package:plogo/features/mypage/widgets/profile_header.dart';
import 'package:plogo/features/mypage/widgets/saved_courses_section.dart';
import 'package:plogo/features/search/widgets/recent_viewed_courses_section.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class MyPageScreen extends StatelessWidget {
	const MyPageScreen({super.key});

	@override
	Widget build(BuildContext context) {
		// 임시 목업 데이터 (API 연동 전)
		final saved = [
			{
				'name': '문경새재 도립공원',
				'location': '경상북도 | 공원',
				'imagePath': 'assets/images/sample.png',
			},
			{
				'name': '안양천 생태아이가든',
				'location': '경기도 | 산',
				'imagePath': 'assets/images/sample.png',
			},
			{
				'name': '주왕산 국립공원',
				'location': '경북 | 산',
				'imagePath': 'assets/images/sample.png',
			},
		];

		return SingleChildScrollView(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const SizedBox(height: 16),
					// 상단 프로필 영역
					const ProfileHeader(
						nickname: '닉네임',
						level: 1,
						levelLabel: '새싹 플로거',
					),
					const SizedBox(height: 16),
					Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: AppColors.greyLight,
              ),
					const SizedBox(height: 16),

					// 저장 목록 섹션
					SavedCoursesSection(
						items: saved,
						onSeeAll: () {},
					),
					const SizedBox(height: 24),

					// 최근 확인한 코스 섹션 (검색 화면의 섹션 재사용)
					const RecentViewedCoursesSection(),
					const SizedBox(height: 24),

										Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: AppColors.greyLight,
              ),
					const SizedBox(height: 8),

					// 설정 영역
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 24),
						child: Column(
							children: [
								ListTile(
									contentPadding: EdgeInsets.zero,
									title: const Text('선호도 재설정'),
									onTap: () {
										// TODO: 온보딩 선호도 질문으로 이동
									},
								),
								ListTile(
									contentPadding: EdgeInsets.zero,
									title: const Text('로그아웃'),
									onTap: () {
										// TODO: 로그아웃 처리
									},
								),
							],
						),
					),
					const SizedBox(height: 24),
				],
			),
		);
	}
}
