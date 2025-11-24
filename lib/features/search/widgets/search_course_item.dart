import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class SearchCourseItem extends StatelessWidget {
  final String query;
  final String name;
  final String address;
  final String iconPath;

  const SearchCourseItem({
    super.key,
    required this.query,
    required this.name,
    required this.address,
    required this.iconPath,
  });

  List<TextSpan> _highlightText(String query, String text) {
    if (query.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.normal,
          ),
        )
      ];
    }

    final lowerQuery = query.toLowerCase();
    final lowerText = text.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index == -1) {
      return [
        TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.normal,
          ),
        )
      ];
    }

    return [
      TextSpan(
        text: text.substring(0, index),
        style: const TextStyle(
          color: AppColors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
      TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      TextSpan(
        text: text.substring(index + query.length),
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: AppColors.greyLight,
                child: iconPath.startsWith('http')
                    ? Image.network(
                        iconPath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image,
                          color: AppColors.grey,
                          size: 30,
                        ),
                      )
                    : Image.asset(
                        iconPath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.image,
                          color: AppColors.grey,
                          size: 30,
                        ),
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
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      children: _highlightText(query, name),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
