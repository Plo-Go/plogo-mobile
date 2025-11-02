import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'course_card.dart';

class RecentViewedCoursesSection extends StatelessWidget {
  const RecentViewedCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '최근 확인한 코스',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 24),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => const CourseCard(
              name: '문경새재 도립공원',
              location: '경상북도 | 공원',
              imagePath: 'assets/images/sample.png',
            ),
          ),
        ),
      ],
    );
  }
}
