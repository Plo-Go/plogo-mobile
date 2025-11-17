import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/shared/widgets/top_bar.dart';
import 'package:plogo/features/home/widgets/course_section.dart';
import 'package:plogo/features/home/services/recommend_service.dart';
import 'package:plogo/features/home/services/hot_course_service.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:plogo/features/home/models/area_code_model.dart';
import 'package:plogo/features/home/services/area_code_service.dart';
import 'package:plogo/features/region/screens/region_list.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 고정된 상단 TopBar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TopBar(),
            ),
            // 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder<CourseRecommendResponse>(
                      future: RecommendService().getRecommendedCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('추천 코스 불러오기 실패'));
                        }
                        final response = snapshot.data;
                        final recommendedItems = (response?.data ?? [])
                            .map((item) => {
                                  'name': item.name,
                                  'location': item.area,
                                  'imagePath': (item.image == null ||
                                          item.image.isEmpty ||
                                          item.image == 'string')
                                      ? ''
                                      : item.image,
                                })
                            .toList();
                        return CourseSection(
                          title: '나를 위한 코스 추천',
                          subtitle: '선호도 기반으로 추천드리는 코스들이에요',
                          items: recommendedItems,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: AppColors.greyLight,
                    ),
                    const SizedBox(height: 20),
                    FutureBuilder<CourseRecommendResponse>(
                      future: HotCourseService().getHotCourses(),
                      builder: (context, hotSnapshot) {
                        if (hotSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (hotSnapshot.hasError) {
                          return Center(child: Text('핫한 코스 불러오기 실패'));
                        }
                        final hotResponse = hotSnapshot.data;
                        final hotItems = (hotResponse?.data ?? [])
                            .map((item) => {
                                  'name': item.name,
                                  'location': item.area,
                                  'imagePath': (item.image == null ||
                                          item.image.isEmpty ||
                                          item.image == 'string')
                                      ? ''
                                      : item.image,
                                })
                            .toList();
                        return CourseSection(
                          title: '요즘 핫한 코스 추천',
                          subtitle: '최근 사용자들 사이에서 인기가 많아요',
                          items: hotItems,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: AppColors.greyLight,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '지역별 코스 찾기',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          FutureBuilder<List<AreaCode>>(
                            future: AreaCodeService().getAreaCodes(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('지역 코드 불러오기 실패'));
                              }
                              final areaCodes = snapshot.data ?? [];
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: areaCodes.map((area) {
                                  return _RegionButton(
                                    label: area.areaName,
                                    areaCode: area.areaCode,
                                    trailingAsset: area.areaCode == 0
                                        ? 'assets/images/arrow.png'
                                        : null,
                                  );
                                }).toList(),
                              );
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: areaCodes.map((area) {
                                  return _RegionButton(
                                    label: area.areaName,
                                    areaCode: area.areaCode,
                                    trailingAsset: area.areaCode == 0
                                        ? 'assets/images/arrow.png'
                                        : null,
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
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

class _RegionButton extends StatelessWidget {
  final String label;
  final int areaCode;
  final String? trailingAsset;
  const _RegionButton(
      {required this.label, required this.areaCode, this.trailingAsset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 3,
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          // GoRouter로 RegionListScreen 이동
          // regionName은 extra로 전달
          context.push('/region/$areaCode', extra: label);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.white,
          side: BorderSide(color: AppColors.greyLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trailingAsset != null) ...[
                const SizedBox(width: 4),
                // 텍스트 베이스라인 대비 아이콘이 살짝 위로 보이는 현상을 보정
                Transform.translate(
                  offset: const Offset(0, 1),
                  child: Image.asset(
                    'assets/icons/arrow.png',
                    width: 9,
                    height: 9,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
