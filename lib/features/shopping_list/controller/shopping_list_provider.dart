import 'package:flutter/material.dart';

class ShoppingListProvider extends ChangeNotifier {
  int _version = 0;

  void refresh() {
    _version++;
    notifyListeners();
  }

  int get version => _version;
}
