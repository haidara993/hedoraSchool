import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/pages/Settings/SettingsPage.dart';
import 'package:madrasatymobile/pages/home_view.dart';
import 'package:madrasatymobile/pages/profile_view.dart';

class ControlViewModel extends GetxController {
  int _navigationValue = 0;
  get navigationValue => _navigationValue;

  Widget _currentScreen = HomeView();

  get currentScreen => _currentScreen;

  void changeSelectedValue(int selectedValue) {
    _navigationValue = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          _currentScreen = HomeView();
          break;
        }
      case 1:
        {
          _currentScreen = SettingPage();
          break;
        }
    }
    update();
  }
}
