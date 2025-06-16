import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plogo/providers/onboarding_provider.dart';
import 'step1_screen.dart';
import 'step2_screen.dart';
import 'step3_screen.dart';
import 'complete_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final step = context.watch<OnboardingProvider>().step;

    switch (step) {
      case 1:
        return const Step1Screen();
      case 2:
        return const Step2Screen();
      case 3:
        return const Step3Screen();
      case 4:
        return const CompleteScreen();
      default:
        return const Step1Screen();
    }
  }
}