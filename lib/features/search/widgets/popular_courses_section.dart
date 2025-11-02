import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class PopularCoursesSection extends StatelessWidget {
  const PopularCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '인기 코스',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _row(1, '주왕산 국립공원', 6, '안양천 생태아이가든'),
          _row(2, '백룡동굴', 7, '한려해상 국립공원'),
          _row(3, '동림저수지', 8, '경안천 습지생태공원'),
          _row(4, '북한산 생태탐방연수원', 9, '목포시 특장자생식물원'),
          _row(5, '무주반디랜드 반딧불이...', 10, '낙동강 하구명소'),
        ],
      ),
    );
  }

  Widget _row(int leftRank, String leftName, int rightRank, String rightName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    '$leftRank',
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
                    leftName,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: Text(
                    '$rightRank',
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
                    rightName,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
