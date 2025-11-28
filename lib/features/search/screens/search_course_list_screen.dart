import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/features/search/screens/search_screen.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/search/services/search_api_service.dart';
import 'package:plogo/shared/widgets/course_list_view.dart';
import 'package:plogo/features/detail/screens/course_detail_screen.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:plogo/features/auth/providers/auth_controller.dart';

class SearchCourseListScreen extends ConsumerStatefulWidget {
  final String keyword;
  final bool isFromRecent;

  const SearchCourseListScreen({
    Key? key,
    required this.keyword,
    this.isFromRecent = false,
  }) : super(key: key);

  @override
  ConsumerState<SearchCourseListScreen> createState() =>
      _SearchCourseListScreenState();
}

class _SearchCourseListScreenState
    extends ConsumerState<SearchCourseListScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = SearchApiService(apiClient.dio).searchCourses(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authProvider.select((s) => s.isLoggedIn));
    if (!isLoggedIn) {
      // 이미 이동 중이면 추가 이동하지 않음
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ModalRoute.of(context)?.isCurrent == true) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          context.go('/login');
        }
      });
      return const SizedBox();
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: GestureDetector(
          onTap: () {
            if (widget.isFromRecent) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SearchScreen(initialKeyword: widget.keyword),
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(12, 10, 20, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 28, color: AppColors.black),
                  onPressed: () {
                    ref.invalidate(recentKeywordsProvider);
                    ref.invalidate(recentCoursesProvider);
                    if (widget.isFromRecent) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              SearchScreen(initialKeyword: widget.keyword),
                        ),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(21),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 42,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.keyword,
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/search.png',
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.search,
                            color: AppColors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('코스 불러오기 실패'));
          }
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return Center(
              child: Text("'${widget.keyword}'의 검색결과가 존재하지 않습니다."),
            );
          }
          return CourseListView(
            title: widget.keyword,
            courses:
                courses.map((e) => CourseRecommendItem.fromJson(e)).toList(),
            onCardTap: (courseId, name) async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(
                    courseId: courseId,
                    title: name,
                  ),
                ),
              );
              setState(() {
                _future = SearchApiService(apiClient.dio)
                    .searchCourses(widget.keyword);
              });
            },
          );
        },
      ),
    );
  }
}
