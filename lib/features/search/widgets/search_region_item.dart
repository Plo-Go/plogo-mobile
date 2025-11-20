import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class SearchRegionItem extends StatelessWidget {
  final String query;
  final String name;
  final String fullName;

  const SearchRegionItem({
    super.key,
    required this.query,
    required this.name,
    required this.fullName,
  });

  List<TextSpan> _highlightText(String query, String text) {
    if (query.isEmpty) {
      return [TextSpan(text: text)];
    }

    final lowerQuery = query.toLowerCase();
    final lowerText = text.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return [TextSpan(text: text)];
    }

    return [
      TextSpan(text: text.substring(0, index)),
      TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(text: text.substring(index + query.length)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(
              AppColors.grey,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/icons/mapIcon.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.location_on,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.grey, fontSize: 16),
                    children: _highlightText(query, name),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fullName,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
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
