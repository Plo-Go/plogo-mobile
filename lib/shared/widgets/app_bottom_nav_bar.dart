import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

/// 앱 전역 하단 네비게이션 바
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double iconSize;
  final double iconLabelGap;
  final double selectedFontSize;
  final double unselectedFontSize;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.iconSize = 24,
    this.iconLabelGap = 2,
    this.selectedFontSize = 10,
    this.unselectedFontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      elevation: 8,
      selectedItemColor: AppColors.black,
      unselectedItemColor: AppColors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: selectedFontSize,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: unselectedFontSize,
        fontWeight: FontWeight.w400,
      ),
      items: [
        _buildNavItem(
          iconPath: 'assets/icons/homeIcon.png',
          activeIconPath: 'assets/icons/homeIcon_filled.png',
          label: '홈',
        ),
        _buildNavItem(
          iconPath: 'assets/icons/mapIcon.png',
          activeIconPath: 'assets/icons/mapIcon_filled.png',
          label: '로그',
        ),
        _buildNavItem(
          iconPath: 'assets/icons/myIcon.png',
          activeIconPath: 'assets/icons/myIcon_filled.png',
          label: '마이',
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String iconPath,
    required String activeIconPath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: iconLabelGap),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: iconLabelGap),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Image.asset(
            activeIconPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              iconPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      label: label,
    );
  }
}
