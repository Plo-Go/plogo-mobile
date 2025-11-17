import 'package:flutter/material.dart';
import 'package:plogo/shared/widgets/app_bottom_nav_bar.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: child,
      ),
      bottomNavigationBar: SizedBox(
        height: barHeight,
        child: AppBottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            onTap(index);
          },
          iconSize: iconSize,
          iconLabelGap: iconLabelGap,
          selectedFontSize: selectedFontSize,
          unselectedFontSize: unselectedFontSize,
        ),
      ),
    );
  }
}
