import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class CourseCard extends StatelessWidget {
  final String name;
  final String location;
  final String imagePath;

  const CourseCard({
    super.key,
    required this.name,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyLight,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.border,
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: AppColors.grey,
                ),
              ),
            ),
          ),
          // 하단 그라데이션 + 텍스트
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // 북마크 아이콘 (배경 없음)
          const Positioned(
            top: 8,
            right: 8,
            child: Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
