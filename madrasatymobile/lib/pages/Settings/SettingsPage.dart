import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/pages/About/About.dart';
import 'package:madrasatymobile/pages/profile_view.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';

class SettingPage extends StatefulWidget {
  static String pageName = "Settings";
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthViewModel>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  settingTiles(
                    context: context,
                    icon: FontAwesomeIcons.user,
                    onTap: () {
                      Get.to(ProfileView());
                    },
                    subtitle: 'Kind of everything we know about you',
                    title: "Profile",
                  ),
                  settingTiles(
                      context: context,
                      icon: FontAwesomeIcons.signOutAlt,
                      onTap: () async {
                        controller.logOut();
                      },
                      subtitle: 'You can login in multiple devices too',
                      title: "Log Out"),
                  settingTiles(
                      context: context,
                      icon: Icons.restore,
                      onTap: () {
                        // kopenPage(context, ForgotPasswordPage());
                      },
                      subtitle: 'Send recovery mail',
                      title: 'Forgot Password'),
                  settingTiles(
                      context: context,
                      icon: Icons.contact_mail,
                      onTap: () async {
                        Get.to(AboutUs());
                      },
                      subtitle: 'Contact us',
                      title: 'About!'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InkWell settingTiles(
      {BuildContext? context,
      VoidCallback? onTap,
      String? title,
      String? subtitle,
      IconData? icon}) {
    return InkWell(
      splashColor: Colors.red[100],
      onTap: onTap,
      child: ListTile(
        trailing: Icon(
          icon,
          color: Theme.of(context!).primaryColor,
        ),
        title: Text(
          title!,
          style: TextStyle(fontWeight: FontWeight.bold
              // fontFamily: 'Ninto',
              ),
        ),
        subtitle: Text(
          subtitle!,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
