import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plogo/providers/onboarding_provider.dart';

class Step3Screen extends StatefulWidget {
  const Step3Screen({super.key});

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  final List<String> options = ['러닝', '걷기', '사진촬영'];
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

    return Scaffold(
      appBar: AppBar(title: const Text('활동')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('함께 할 활동 (최대 2개)', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: options.map((option) {
                final isSelected = selected.contains(option);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => toggleSelect(option),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selected.isNotEmpty
                  ? () {
                provider.setActivity(selected);
                provider.nextStep();
              }
                  : null,
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}