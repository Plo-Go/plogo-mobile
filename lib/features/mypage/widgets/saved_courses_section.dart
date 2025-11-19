import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';
import 'package:plogo/shared/widgets/course_card.dart';
import 'package:go_router/go_router.dart';

class SavedCoursesSection extends StatelessWidget {
  final VoidCallback? onSeeAll;
  final List<Map<String, dynamic>> items; // [{name, area, image, ...}]
  final Future<void> Function(int courseId, String name)? onCardTap;

  const SavedCoursesSection({
    super.key,
    this.onSeeAll,
    this.items = const [],
    this.onCardTap,
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
                  onPressed: () async {
                    final result = await context.push('/mypage/saved-courses');
                    if (result == true && onSeeAll != null) {
                      onSeeAll!(); // 저장목록 섹션 새로고침
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '전체 보기',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Transform.translate(
                        offset: const Offset(0, 1),
                        child: Image.asset(
                          'assets/icons/arrow.png',
                          width: 8,
                          height: 8,
                          color: AppColors.grey,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.arrow_forward_ios,
                            size: 8,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            height: 128,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.center,
            child: const Text(
              '저장한 코스가 없습니다.',
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          )
        else
          SizedBox(
            height: 128,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 24),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final isLast = i == items.length - 1;
                return Row(
                  children: [
                    CourseCard(
                      name: item['name'] ?? '이름',
                      location: item['area'] ?? '위치',
                      imagePath: item['image'] ?? 'assets/images/sample.png',
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
