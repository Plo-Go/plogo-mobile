import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_item.dart';
import 'package:plogo/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OnboardingProvider>(context);
    final step = provider.steps[currentStep];
    final selected = provider.selected[currentStep];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: currentStep > 0,  // 첫 화면만 back 버튼 숨김
        elevation: 0,
        backgroundColor: Colors.white,
        leading: currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            setState(() {
              currentStep--;
            });
          },
        )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.stepNumber, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Text(step.title, style: const TextStyle(fontSize: 24)),
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
                  children: step.options.entries.map((entry) {
                    final isSelected = selected.contains(entry.key);
                    return SizedBox(
                      width: itemWidth,
                      child: OnboardingItem(
                        label: entry.key,
                        imagePath: entry.value,
                        isSelected: isSelected,
                        itemWidth: itemWidth,
                        onTap: () {
                          provider.toggleSelect(currentStep, entry.key);
                        },
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
                  if (currentStep + 1 < provider.steps.length) {
                    setState(() {
                      currentStep++;
                    });
                  } else {
                    context.go('/onboarding_complete_screen');
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: selected.isNotEmpty ? AppColors.primary : AppColors.grey,
                ),
                child: Text(
                  currentStep == provider.steps.length - 1 ? '완료' : '다음',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}