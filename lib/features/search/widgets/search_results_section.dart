import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';
import 'package:plogo/features/region/screens/sigungu_course_list_screen.dart';
import 'package:plogo/features/detail/screens/course_detail_screen.dart';


class SearchResultsSection extends ConsumerWidget {
  final String query;
  final bool isSearchConfirmed;
  final void Function(String regionName)? onRegionTap;
  const SearchResultsSection({required this.query, required this.isSearchConfirmed, this.onRegionTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // 검색 확정 여부에 따라 Provider 분기
  final regionResults = isSearchConfirmed
    ? ref.watch(regionResultsProvider(query))
    : AsyncValue.data(ref.watch(filteredRegionProvider(query)));
  final courseResults = isSearchConfirmed
    ? ref.watch(courseResultsProvider(query))
    : AsyncValue.data(ref.watch(filteredCourseProvider(query)));
    return ListView(
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
      children: [
        regionResults.when(
          data: (regions) {
            // 입력 중: 지역/코스 모두 없을 때만 안내 메시지 표시
            if (!isSearchConfirmed) {
              final courses = courseResults.value ?? [];
              if (regions.isEmpty && courses.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      '일치하는 검색어가 없습니다',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                );
              }
              // 지역 결과만 표시
              return regions.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: regions
                          .map((region) => GestureDetector(
                                onTap: () {
                                  if (onRegionTap != null) {
                                    onRegionTap!(region['sigunguName'] ?? '');
                                  }
                                },
                                child: SearchRegionItem(
                                  query: query,
                                  name: region['sigunguName'] ?? '',
                                  fullName: region['withArea'] ?? '',
                                ),
                              ))
                          .toList(),
                    );
            } else {
              // 검색 확정 시 기존대로 지역 결과 숨김
              return const SizedBox();
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
        const SizedBox(height: 20),
        courseResults.when(
          data: (courses) {
            if (!isSearchConfirmed) {
              // 입력 중에는 코스 결과만 표시, 안내 메시지는 regionResults에서 처리
              return courses.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: courses
                          .map((course) => GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailScreen(
                                        courseId: course['course_id'],
                                        title: course['name'],
                                      ),
                                    ),
                                  );
                                  ref.invalidate(recentCoursesProvider);
                                },
                                child: SearchCourseItem(
                                  query: query,
                                  name: course['name'] ?? '',
                                  address: course['area'] ?? '',
                                  iconPath: (course['image'] != null &&
                                          course['image'].toString().isNotEmpty)
                                      ? course['image']
                                      : 'assets/images/no_image.png',
                                ),
                              ))
                          .toList(),
                    );
            } else {
              // 검색 확정 시 기존대로 안내 메시지 표시
              return courses.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          '검색 결과가 없습니다',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: courses
                          .map((course) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailScreen(
                                        courseId: course['course_id'],
                                        title: course['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: SearchCourseItem(
                                  query: query,
                                  name: course['name'] ?? '',
                                  address: course['area'] ?? '',
                                  iconPath: (course['image'] != null &&
                                          course['image'].toString().isNotEmpty)
                                      ? course['image']
                                      : 'assets/images/no_image.png',
                                ),
                              ))
                          .toList(),
                    );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
