import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/mypage/services/mypage_service.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:plogo/shared/widgets/course_list_view.dart';
import 'package:plogo/core/api/api_client.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

class SavedCoursesListScreen extends StatefulWidget {
  const SavedCoursesListScreen({super.key});

  @override
  State<SavedCoursesListScreen> createState() => _SavedCoursesListScreenState();
}

class _SavedCoursesListScreenState extends State<SavedCoursesListScreen> {
  List<Map<String, dynamic>> _savedCourses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSavedCourses();
  }

  Future<void> _fetchSavedCourses() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await MyPageService(apiClient.dio).getSavedCourses();
      setState(() {
        _savedCourses = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '저장 코스 불러오기 실패';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: const Text(
          '저장목록',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 4,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _savedCourses.isEmpty
                  ? const Center(child: Text('저장한 코스가 없습니다.'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _savedCourses.length,
                      separatorBuilder: (_, __) => Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 8,
                            color: AppColors.greyLight,
                          ),
                        ],
                      ),
                      itemBuilder: (context, i) {
                        final item = _savedCourses[i];
                        final course = CourseRecommendItem(
                          courseId: item['course_id'] ?? item['courseId'] ?? 0,
                          image: item['image'] ?? '',
                          area: item['area'] ?? '',
                          name: item['name'] ?? '',
                          isSave: item['isSave'] == true,
                        );
                        return GestureDetector(
                          onTap: () async {
                            final location =
                                GoRouterState.of(context).matchedLocation;
                            String detailRoute;
                            if (location.startsWith('/log')) {
                              detailRoute = '/log/detail/${course.courseId}';
                            } else if (location.startsWith('/mypage')) {
                              detailRoute = '/mypage/detail/${course.courseId}';
                            } else {
                              detailRoute = '/home/detail/${course.courseId}';
                            }
                            await context.push(detailRoute, extra: course.name);
                            _fetchSavedCourses();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 18),
                                          Text(course.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          const SizedBox(height: 4),
                                          Text(course.area,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.grey)),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      course.isSave
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: course.image.isNotEmpty
                                      ? Image.network(
                                          course.image,
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 160,
                                          color: AppColors.greyLight,
                                          child: const Center(
                                              child: Icon(Icons.image,
                                                  color: AppColors.grey,
                                                  size: 40)),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
