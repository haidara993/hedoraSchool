// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/pages/auth/login_view.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/control_viewmoldel.dart';

class ControlView extends GetWidget<AuthViewModel> {
  const ControlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthViewModel>().isLogged.value == false)
          ? LoginView()
          : GetBuilder<ControlViewModel>(
              init: ControlViewModel(),
              builder: (controller) {
                return Scaffold(
                  bottomNavigationBar: _bottomNavigationBar(),
                  body: controller.currentScreen,
                );
              },
            );
    });
  }

  Widget _bottomNavigationBar() {
    return GetBuilder<ControlViewModel>(
      builder: (controller) {
        return BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: controller.navigationValue,
          onTap: (value) {
            controller.changeSelectedValue(value);
          },
        );
      },
    );
  }
}
