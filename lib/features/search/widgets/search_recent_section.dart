import 'package:plogo/features/search/screens/search_course_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/features/search/services/search_service.dart';
import 'package:plogo/features/search/screens/search_screen.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../widgets/recent_searches.dart';
import '../widgets/recent_viewed_courses_section.dart';
import '../widgets/popular_courses_section.dart';

class SearchRecentSection extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController? searchController;
  const SearchRecentSection({this.focusNode, this.searchController, super.key});

  @override
  State<SearchRecentSection> createState() => _SearchRecentSectionState();
}

class _SearchRecentSectionState extends State<SearchRecentSection> {
  // didChangeDependencies에서 recentKeywordsProvider refresh 제거

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final recentKeywords = ref.watch(recentKeywordsProvider);
        recentKeywords.when(
          data: (keywords) => print('[최근검색어 리스트] $keywords'),
          loading: () {},
          error: (_, __) {},
        );
        final recentCourses = ref.watch(recentCoursesProvider);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              recentKeywords.when(
                data: (keywords) => RecentSearches(
                  keywords: keywords,
                  onDelete: (keyword) async {
                    final success = await SearchService(apiClient.dio)
                        .deleteKeyword(keyword);
                    if (success) {
                      ref.refresh(recentKeywordsProvider);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('검색어 삭제에 실패했습니다')),
                      );
                    }
                  },
                  onTap: (keyword) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            SearchCourseListScreen(keyword: keyword),
                      ),
                    );
                  },
                ),
                loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 검색어 불러오기 실패',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 32),
              recentCourses.when(
                data: (items) => RecentViewedCoursesSection(
                  items: items,
                  onCardTap: (courseId, name) async {
                    if (context.mounted) {
                      await context.push('/home/detail/$courseId', extra: name);
                      ref.refresh(recentCoursesProvider);
                    }
                  },
                ),
                loading: () => const SizedBox(
                    height: 128,
                    child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text('최근 확인한 코스 불러오기 실패',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 32),
              PopularCoursesSection(
                onRefreshRecentCourses: () {
                  ref.refresh(recentCoursesProvider);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
