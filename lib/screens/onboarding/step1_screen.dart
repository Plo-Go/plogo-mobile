import 'package:flutter/material.dart';
import 'package:plogo/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:plogo/providers/onboarding_provider.dart';
import 'package:plogo/widgets/app_layout.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final Map<String, String> options = {
    '산': 'assets/images/mountain.png',
    '바다': 'assets/images/beach.png',
    '동굴': 'assets/images/cave.png',
  };
  final List<String> selected = [];

  void toggleSelect(String option) {
    setState(() {
      if (selected.contains(option)) {
        selected.remove(option);
      } else if (selected.length < 2) {
        selected.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context, listen: false);

    return AppLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const Text(
            '1',
            style: TextStyle(fontSize: 60, fontWeight: FontWeight.w700),
          ),
          const Text(
            '다음 중 평소 선호하는\n자연경관은?\n(최대 2개 선택)',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
          ),
          const SizedBox(height: 50),
          LayoutBuilder(
            builder: (context, constraints) {
              double totalWidth = constraints.maxWidth;
              int crossCount = 3;
              double spacing = 16;
              double itemWidth = (totalWidth - (crossCount - 1) * spacing) / crossCount;

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: spacing,
                runSpacing: spacing,
                children: options.entries.map((entry) {
                  final isSelected = selected.contains(entry.key);
                  return SizedBox(
                    width: itemWidth,
                    child: GestureDetector(
                      onTap: () => toggleSelect(entry.key),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              // 테두리 공간 확보를 위해 padding 삽입
                              Padding(
                                padding: const EdgeInsets.all(3), // 테두리 두께만큼 padding
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    entry.value,
                                    fit: BoxFit.cover,
                                    width: itemWidth - 6, // 패딩 고려해서 -6 (좌우 각각 3)
                                    height: (itemWidth - 6) * 1.2,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? AppColors.primary : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selected.isNotEmpty
                  ? () {
                provider.setNature(selected);
                provider.nextStep();
              }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: selected.isNotEmpty
                    ? AppColors.primary
                    : AppColors.grey,
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
