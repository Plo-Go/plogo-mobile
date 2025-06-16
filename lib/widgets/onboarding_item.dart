import 'package:flutter/material.dart';
import 'package:plogo/theme/app_colors.dart';

class OnboardingItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final String imagePath;
  final VoidCallback onTap;
  final double itemWidth;

  const OnboardingItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.imagePath,
    required this.onTap,
    required this.itemWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: itemWidth - 6,
                    height: (itemWidth - 6) * 1.2,
                  ),
                ),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}