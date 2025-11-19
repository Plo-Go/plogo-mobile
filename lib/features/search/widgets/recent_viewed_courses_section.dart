import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/shared/widgets/course_card.dart';

class RecentViewedCoursesSection extends StatelessWidget {
  final List<Map<String, String>> items; // [{name, location, imagePath}]

  const RecentViewedCoursesSection({
    super.key,
    this.items = const [],
  });

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
        if (items.isEmpty)
          Container(
            height: 128,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: Text(
              '최근 확인한 코스가 없습니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final item = items[i];
                return CourseCard(
                  name: item['name'] ?? '이름',
                  location: item['location'] ?? '위치',
                  imagePath: item['imagePath'] ?? 'assets/images/sample.png',
                  isSave: item['isSave'] == true,
                );
              },
            ),
          ),
      ],
    );
  }
}
