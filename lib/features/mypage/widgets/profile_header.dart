import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String nickname;
  final int level; // 1~5 가정
  final String levelLabel; // 예: '새싹 플로거'

  const ProfileHeader({
    super.key,
    required this.nickname,
    required this.level,
    required this.levelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '마이 페이지',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 아바타
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greyLight,
                ),
                child: const Icon(Icons.person, color: AppColors.grey, size: 32),
              ),
              const SizedBox(width: 16),
              // 닉네임/레벨/깃발
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '레벨 $level ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                          ),
                        ),
                         Text(
                            levelLabel,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (i) {
                        // PNG 캔버스 크기는 같지만 실제 깃발 비주얼이 다름 -> 크기 보정
                        const double filledSize = 24.0; // 채워진 깃발: 여백이 많아서 확대
                        const double emptySize = 22.0;  // 빈 깃발: 기본 크기
                        final filled = i < level;
                        final size = filled ? filledSize : emptySize;
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            right: i == 4 ? 0 : 2,
                          ),
                          child: Container(
                            width: 24, // 최대 크기 기준 셀
                            height: 24,
                            alignment: Alignment.bottomCenter, // 하단 기준 정렬
                            decoration: filled ? BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.16),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ) : null,
                            child: Transform.translate(
                              offset: filled ? const Offset(0, 2) : Offset.zero, // 채워진 깃발만 시각적으로 1px 아래로 이동 (레이아웃 영향 없음)
                              child: Image.asset(
                                filled
                                    ? 'assets/icons/flag_filled.png'
                                    : 'assets/icons/flag_empty.png',
                                width: size,
                                height: size,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.flag,
                                  size: size,
                                  color: filled ? AppColors.primary : AppColors.greyLight,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
