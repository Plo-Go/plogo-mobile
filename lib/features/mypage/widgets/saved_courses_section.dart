import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/features/search/widgets/course_card.dart';

class SavedCoursesSection extends StatelessWidget {
  final VoidCallback? onSeeAll;
  final List<Map<String, String>> items; // [{name, location, imagePath}]

  const SavedCoursesSection({
    super.key,
    this.onSeeAll,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '저장 목록',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (items.isNotEmpty)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    '전체 보기',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '저장한 코스가 없습니다.',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          )
        else
          SizedBox(
            height: 160,
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
                );
              },
            ),
          ),
      ],
    );
  }
}
