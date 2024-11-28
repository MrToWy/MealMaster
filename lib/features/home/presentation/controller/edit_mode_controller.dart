import 'package:flutter/material.dart';

class EditModeProvider with ChangeNotifier {
  bool _inEditMode = false;

  bool get inEditMode => _inEditMode;

  void setEditMode(bool value) {
    _inEditMode = value;
    notifyListeners();
  }
}
