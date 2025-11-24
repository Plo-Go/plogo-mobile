import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plogo/features/search/providers/search_provider.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/search/services/search_api_service.dart';
import 'package:plogo/shared/widgets/course_list_view.dart';
import 'package:plogo/features/detail/screens/course_detail_screen.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:plogo/features/home/models/course_models.dart';

class SearchCourseListScreen extends ConsumerStatefulWidget {
  final String keyword;
  const SearchCourseListScreen({super.key, required this.keyword});

  @override
  ConsumerState<SearchCourseListScreen> createState() => _SearchCourseListScreenState();
}

class _SearchCourseListScreenState extends ConsumerState<SearchCourseListScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = SearchApiService(apiClient.dio).searchCourses(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () {
            ref.invalidate(recentKeywordsProvider);
            ref.invalidate(recentCoursesProvider);
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.keyword,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('코스 불러오기 실패'));
          }
          final courses = snapshot.data ?? [];
          if (courses.isEmpty) {
            return const Center(child: Text('검색 결과가 없습니다.'));
          }
          return CourseListView(
            title: widget.keyword,
            courses: courses.map((e) => CourseRecommendItem.fromJson(e)).toList(),
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
