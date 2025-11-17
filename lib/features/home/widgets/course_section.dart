import 'package:flutter/material.dart';
import 'package:plogo/shared/widgets/course_card.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class CourseSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Map<String, String>> items; // [{name, location, imagePath}]

  const CourseSection({
    super.key,
    required this.title,
    this.subtitle,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 14, color: AppColors.grey),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
        if (items.isEmpty)
          Container(
            height: 128,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: const Text(
              '표시할 코스가 없습니다.',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final item = items[i];
                return CourseCard(
                  name: item['name'] ?? '이름',
                  location: item['location'] ?? '위치',
                  imagePath: item['imagePath'] ?? 'assets/images/sample.png',
                );
              },
            ),
          ),
      ],
    );
  }
}
