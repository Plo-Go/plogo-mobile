import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/home/models/course_models.dart';
import 'package:go_router/go_router.dart';

class CourseListView extends StatelessWidget {
  final String title;
  final List<CourseRecommendItem> courses;
  final Widget? topWidget;
  const CourseListView({
    super.key,
    required this.title,
    required this.courses,
    this.topWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: courses.isEmpty
              ? const Center(child: Text('코스가 없습니다.'))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: courses.length,
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
                    final course = courses[i];
                    return GestureDetector(
                      onTap: () {
                        // 상세페이지 이동
                        // 현재 route에 따라 상세페이지 경로 결정
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
                        context.push(detailRoute, extra: course.name);
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
                                  : Image.asset(
                                      'assets/images/no_image.png',
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
