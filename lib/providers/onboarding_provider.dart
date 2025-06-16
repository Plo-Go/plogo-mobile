import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _step = 1;
  int get step => _step;

  List<String> nature = [];
  List<String> policy = [];
  List<String> activity = [];

  void nextStep() {
    _step++;
    notifyListeners();
  }

  void setNature(List<String> selected) {
    nature = selected;
    notifyListeners();
  }

  void setPolicy(List<String> selected) {
    policy = selected;
    notifyListeners();
  }

  void setActivity(List<String> selected) {
    activity = selected;
    notifyListeners();
  }

  void reset() {
    _step = 1;
    nature = [];
    policy = [];
    activity = [];
    notifyListeners();
  }
}