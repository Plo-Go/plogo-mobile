import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/shared/widgets/course_card.dart';
import 'package:go_router/go_router.dart';

class RecentViewedCoursesSection extends StatelessWidget {
  final List<Map<String, dynamic>> items; // [{name, area, image, isSave}]
  final VoidCallback? onRefresh;
  final Future<void> Function(int courseId, String name)? onCardTap;

  const RecentViewedCoursesSection({
    super.key,
    this.items = const [],
    this.onRefresh,
    this.onCardTap,
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
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final isLast = i == items.length - 1;
                return Row(
                  children: [
                    CourseCard(
                      name: item['name'] ?? '이름',
                      location: item['area'] ?? item['location'] ?? '위치',
                      imagePath: item['image'] ?? item['imagePath'] ?? 'assets/images/sample.png',
                      isSave: item['isSave'] == true,
                      onTap: () async {
                        final courseId = item['course_id'] ?? item['courseId'];
                        final name = item['name'] ?? '';
                        if (courseId != null && onCardTap != null) {
                          await onCardTap!(courseId, name);
                        }
                      },
                    ),
                    if (!isLast)
                      const SizedBox(width: 12)
                    else
                      const SizedBox(width: 24),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
