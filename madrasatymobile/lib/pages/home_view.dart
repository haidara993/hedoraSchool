import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/pages/Announcement/AnnouncementPage.dart';
import 'package:madrasatymobile/pages/Assignment/AssignmentPage.dart';
import 'package:madrasatymobile/pages/e_card_view.dart';
import 'package:madrasatymobile/pages/widgets/ColumnReusableCardButton.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/control_viewmoldel.dart';
import 'package:madrasatymobile/viewmodel/home_viewmodel.dart';

class HomeView extends GetWidget<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  ImageProvider<Object> setImage() {
    // print(user.photoUrl);

    if (Get.find<AuthViewModel>().user?.photoUrl != 'default') {
      return NetworkImage(
        (Get.find<AuthViewModel>().user?.photoUrl)!,
      );
    } else {
      return AssetImage('assets/students.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          title: 'Home',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: Image(
              image: setImage(),
              height: 30,
              width: 30,
            ),
          ),
          onPressed: () {
            Get.find<ControlViewModel>().changeSelectedValue(1);
          }),
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              children: [
                // ColumnReusableCardButton(
                //   onPressed: () {
                //     // kopenPage(context, ChildrensPage());
                //   },
                //   icon: FontAwesomeIcons.child,
                //   label: "Childrens",
                //   tileColor: Colors.deepPurpleAccent,
                //   directionIconHeroTag: "Childrens",
                //   height: 100,
                // ),
                ColumnReusableCardButton(
                  onPressed: () {
                    // kopenPage(context, ECardPage());
                    Get.to(ECardView());
                  },
                  icon: Icons.perm_contact_calendar,
                  label: "E-Card",
                  tileColor: Colors.deepOrangeAccent,
                  directionIconHeroTag: "E-Card",
                  height: 100,
                ),
                ColumnReusableCardButton(
                  onPressed: () {
                    // kopenPage(context, TimeTablePage());
                  },
                  icon: Icons.av_timer,
                  label: "TimeTable",
                  tileColor: Colors.yellow,
                  directionIconHeroTag: "TimeTable",
                  height: 100,
                ),
                ColumnReusableCardButton(
                  directionIconHeroTag: "Announcement",
                  height: 100,
                  tileColor: Colors.orangeAccent,
                  label: "Announcement",
                  icon: Icons.announcement_sharp,
                  onPressed: () {
                    // kopenPage(context, AnnouncementPage());
                    Get.to(AnnouncementPage());
                  },
                ),
                ColumnReusableCardButton(
                  directionIconHeroTag: "Assignments",
                  height: 100,
                  tileColor: Colors.lightGreen,
                  label: "Assignments",
                  icon: Icons.assessment,
                  onPressed: () {
                    // kopenPage(context, AssignmentsPage());
                    Get.to(AssignmentsPage());
                  },
                ),
                ColumnReusableCardButton(
                  directionIconHeroTag: "Holidays",
                  height: 100,
                  tileColor: Colors.blueGrey,
                  label: "Holidays",
                  icon: Icons.wallet_travel_sharp,
                  onPressed: () {
                    // kopenPage(context, HolidayPage());
                  },
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
