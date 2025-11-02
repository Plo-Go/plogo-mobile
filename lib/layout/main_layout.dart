import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

/// 앱 전역 하단바 레이아웃
/// - 온보딩 이외의 화면에서 사용 (GoRouter ShellRoute에서 감쌈)
class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int> onTap;

  // 커스텀 가능 포인트
  final double barHeight; // 하단바 전체 높이
  final double iconSize; // 아이콘 크기
  final double iconLabelGap; // 아이콘과 라벨 사이 간격
  final double selectedFontSize; // 선택 라벨 폰트 크기
  final double unselectedFontSize; // 비선택 라벨 폰트 크기

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
    this.barHeight = 80,
    this.iconSize = 24,
    this.iconLabelGap = 2,
    this.selectedFontSize = 10,
    this.unselectedFontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: SizedBox(
        height: barHeight,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.white,
          elevation: 8,
          selectedItemColor: AppColors.black,
          unselectedItemColor: AppColors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontSize: selectedFontSize, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: unselectedFontSize, fontWeight: FontWeight.w400),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: iconLabelGap),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Image.asset(
                    'assets/icons/homeIcon.png',
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
                    'assets/icons/homeIcon_filled.png',
                    fit: BoxFit.contain,
                    // 채워진 아이콘이 없다면 기본 아이콘을 그대로 사용
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/icons/homeIcon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: iconLabelGap),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Image.asset(
                    'assets/icons/mapIcon.png',
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
                    'assets/icons/mapIcon_filled.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/icons/mapIcon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              label: '로그',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: iconLabelGap),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Image.asset(
                    'assets/icons/myIcon.png',
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
                    'assets/icons/myIcon_filled.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/icons/myIcon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              label: '마이',
            ),
          ],
        ),
      ),
    );
  }
}
