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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '최근 검색어',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: keywords.map((keyword) {
              return Chip(
                label: Text(keyword),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => onDelete(keyword),
                backgroundColor: AppColors.greyLight,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
