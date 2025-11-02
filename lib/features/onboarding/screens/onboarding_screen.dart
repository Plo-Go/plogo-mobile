import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_item.dart';
import 'package:plogo/shared/theme/app_colors.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(onboardingProvider);
    final step = OnboardingNotifier.steps[currentStep];
    final stepSelections = selected[currentStep];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            if (currentStep > 0)
              Container(
                height: 56,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      currentStep--;
                    });
                  },
                ),
              )
            else
              const SizedBox(height: 56),
            Expanded(
              child: Padding(
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
                    final isSelected = stepSelections.contains(entry.key);
                    return SizedBox(
                      width: itemWidth,
                      child: OnboardingItem(
                        label: entry.key,
                        imagePath: entry.value,
                        isSelected: isSelected,
                        itemWidth: itemWidth,
                        onTap: () {
                          ref.read(onboardingProvider.notifier).toggleSelect(currentStep, entry.key);
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
                onPressed: stepSelections.isNotEmpty
                    ? () {
                  if (currentStep + 1 < OnboardingNotifier.steps.length) {
                    setState(() {
                      currentStep++;
                    });
                  } else {
                    context.go('/onboarding-complete');
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: stepSelections.isNotEmpty ? AppColors.primary : AppColors.grey,
                ),
                child: Text(
                  currentStep == OnboardingNotifier.steps.length - 1 ? '완료' : '다음',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

