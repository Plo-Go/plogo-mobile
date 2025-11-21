import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/home/services/hot_course_service.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:go_router/go_router.dart';

class PopularCoursesSection extends StatefulWidget {
  final VoidCallback? onRefreshRecentCourses;

  const PopularCoursesSection({super.key, this.onRefreshRecentCourses});

  @override
  State<PopularCoursesSection> createState() => _PopularCoursesSectionState();
}

class _PopularCoursesSectionState extends State<PopularCoursesSection> {
  late Future<CourseRecommendResponse> _hotCoursesFuture;

  @override
  void initState() {
    super.initState();
    _hotCoursesFuture = HotCourseService().getHotCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FutureBuilder<CourseRecommendResponse>(
        future: _hotCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text('인기 코스 불러오기 실패', style: TextStyle(color: Colors.red));
          }
          final courses = snapshot.data?.data ?? [];
          if (courses.isEmpty) {
            return const Text('인기 코스가 없습니다');
          }
          final half = (courses.length / 2).ceil();
          final leftList = courses.take(half).toList();
          final rightList = courses.skip(half).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '인기 코스',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: List.generate(leftList.length, (i) {
                        final course = leftList[i];
                        return _courseItem(course, i + 1);
                      }),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: List.generate(rightList.length, (i) {
                        final course = rightList[i];
                        return _courseItem(course, half + i + 1);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _courseItem(CourseRecommendItem course, int rank) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: InkWell(
        onTap: () async {
          await context.push('/home/detail/${course.courseId}', extra: course.name);
          if (widget.onRefreshRecentCourses != null) {
            widget.onRefreshRecentCourses!();
          }
        },
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                course.name,
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
