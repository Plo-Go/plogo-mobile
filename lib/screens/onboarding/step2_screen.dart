import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plogo/providers/onboarding_provider.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({super.key});

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final List<String> options = ['탄소중립', '쓰레기줍기', '환경교육'];
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
      appBar: AppBar(title: const Text('정책')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('필요한 환경정책 (최대 2개)', style: TextStyle(fontSize: 18)),
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
                provider.setPolicy(selected);
                provider.nextStep();
              }
                  : null,
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
