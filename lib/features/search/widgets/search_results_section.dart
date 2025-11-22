import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import '../widgets/search_region_item.dart';
import '../widgets/search_course_item.dart';

class SearchResultsSection extends ConsumerWidget {
  final String query;
  const SearchResultsSection({required this.query, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionResults = ref.watch(regionResultsProvider(query));
    final courseResults = ref.watch(courseResultsProvider(query));
    return ListView(
      padding: const EdgeInsets.only(top: 0, bottom: 12, left: 12, right: 12),
      children: [
        regionResults.when(
          data: (regions) => regions.isEmpty
              ? const SizedBox()
              : Column(
                  children: regions.map((region) => SearchRegionItem(
                    query: query,
                    name: region['sigunguName'] ?? '',
                    fullName: region['withArea'] ?? '',
                  )).toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
        const SizedBox(height: 20),
        courseResults.when(
          data: (courses) => courses.isEmpty
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
                  children: courses.map((course) => SearchCourseItem(
                    query: query,
                    name: course['name'] ?? '',
                    address: course['area'] ?? '',
                    iconPath: course['image'] ?? 'assets/images/sample.png',
                  )).toList(),
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
        ),
      ],
    );
  }
}
