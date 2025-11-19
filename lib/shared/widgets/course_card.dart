import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class CourseCard extends StatelessWidget {
  final String name;
  final String location;
  final String imagePath;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.name,
    required this.location,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
  final isNetworkImage =
    imagePath.startsWith('http://') || imagePath.startsWith('https://');
  final isEmptyImage = imagePath.isEmpty || imagePath == 'string';
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyLight,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: isEmptyImage
                ? Image.asset(
                    'assets/images/no_image.png',
                    fit: BoxFit.cover,
                  )
                : isNetworkImage
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('[이미지 로딩 에러] URL: $imagePath, error: $error');
                          return Image.asset(
                            'assets/images/no_image.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/no_image.png',
                          fit: BoxFit.cover,
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
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
