import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class RecentSearches extends StatelessWidget {
  final List<String> keywords;
  final Function(String) onDelete;

  const RecentSearches({
    super.key,
    required this.keywords,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '최근 검색어',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 24, right: 24),
            scrollDirection: Axis.horizontal,
            itemCount: keywords.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final keyword = keywords[index];
              return Chip(
                label: Text(
                  keyword,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.grey,
                ),
                onDeleted: () => onDelete(keyword),
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: AppColors.greyLight),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              );
            },
          ),
        ),
      ],
    );
  }
}
