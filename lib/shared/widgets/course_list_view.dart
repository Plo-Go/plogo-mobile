import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/home/models/course_models.dart';

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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 18),
                                    Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    const SizedBox(height: 4),
                                    Text(course.area, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                                  ],
                                ),
                              ),
                              Icon(
                                course.isSave ? Icons.bookmark : Icons.bookmark_border,
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
                                    child: const Center(child: Icon(Icons.image, color: AppColors.grey, size: 40)),
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
