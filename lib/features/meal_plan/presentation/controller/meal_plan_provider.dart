import 'package:flutter/material.dart';

class MealPlanProvider extends ChangeNotifier {
  int _version = 0;

  void refresh() {
    _version++;
    notifyListeners();
  }

  int get version => _version;
}
