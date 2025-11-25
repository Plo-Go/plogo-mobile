import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String nickname;
  final int level; // 1~5 가정
  final String levelLabel; // 예: '새싹 플로거'
  final String? profileImg;
  final int stampCount;

  const ProfileHeader({
    super.key,
    required this.nickname,
    required this.level,
    required this.levelLabel,
    this.profileImg,
    required this.stampCount,
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
                clipBehavior: Clip.hardEdge,
                child: profileImg != null && profileImg!.isNotEmpty
                    ? Image.network(
                        profileImg!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person,
                                color: AppColors.grey, size: 32),
                      )
                    : const Icon(Icons.person, color: AppColors.grey, size: 32),
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
                        // 깃발 개수 계산을 더 간단하게
                        const double filledSize = 24.0;
                        const double emptySize = 22.0;
                        final filled = i < stampCount;
                        final size = filled ? filledSize : emptySize;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: i == 4 ? 0 : 2,
                          ),
                          child: Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.bottomCenter,
                            decoration: filled
                                ? BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.16),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  )
                                : null,
                            child: Transform.translate(
                              offset: filled ? const Offset(0, 2) : Offset.zero,
                              child: Image.asset(
                                filled
                                    ? 'assets/icons/flag_filled.png'
                                    : 'assets/icons/flag_empty.png',
                                width: size,
                                height: size,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.flag,
                                  size: size,
                                  color: filled
                                      ? AppColors.primary
                                      : AppColors.greyLight,
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
