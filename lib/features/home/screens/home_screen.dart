import 'package:flutter/material.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // 상단 로고 + 검색창
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/search.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                        ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 18),
                                hintText: '코스를 검색해 보세요!',
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 나를 위한 코스 추천
              const Text(
                '나를 위한 코스 추천',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                '선호도 기반으로 추천드리는 코스들이에요',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
                  ],
                ),
              ),

              SizedBox(
                height: 150,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          color: AppColors.border,
                          child: const Icon(Icons.image, size: 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '문정새싹 둔촌코스',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: AppColors.greyLight,
              ),
              const SizedBox(height: 20),

              // 요즘 핫한 코스 추천
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '요즘 핫한 코스 추천',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '최근 사용자들 사이에서 인기가 많아요',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              SizedBox(
                height: 150,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: double.infinity,
                          color: AppColors.border,
                          child: const Icon(Icons.image, size: 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '성수 리버뷰 코스',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: AppColors.greyLight,
              ),
              const SizedBox(height: 20),

              // 지역별 코스 찾기
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '지역별 코스 찾기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _RegionButton(label: '전체', trailingAsset: 'assets/images/arrow.png'),
                  _RegionButton(label: '서울'),
                  _RegionButton(label: '인천'),
                  _RegionButton(label: '부산'),
                  _RegionButton(label: '대구'),
                  _RegionButton(label: '광주'),
                  _RegionButton(label: '울산'),
                  _RegionButton(label: '세종'),
                  _RegionButton(label: '경기도'),
                  _RegionButton(label: '강원도'),
                  _RegionButton(label: '충청도'),
                        _RegionButton(label: '전라도'),
                      ],
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegionButton extends StatelessWidget {
  final String label;
  final String? trailingAsset;
  const _RegionButton({required this.label, this.trailingAsset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 3, // 3열 맞춤
      height: 44,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.white,
          side: BorderSide(color: AppColors.greyLight), // 테두리 색상을 greyLight로 변경
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (trailingAsset != null) ...[
                const SizedBox(width: 4),
                  // 텍스트 베이스라인 대비 아이콘이 살짝 위로 보이는 현상을 보정
                  Transform.translate(
                    offset: const Offset(0, 1), // 필요 시 0~2 사이로 미세 조정
                    child: Image.asset(
                      'assets/icons/arrow.png',
                      width: 9,
                      height: 9,
                      fit: BoxFit.contain,
                      // 에셋이 없을 경우 기본 아이콘으로 대체
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.black,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
