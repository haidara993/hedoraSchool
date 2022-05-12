import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/enums/UserType.dart';
import 'package:madrasatymobile/pages/Announcement/CreateAnnouncement.dart';
import 'package:madrasatymobile/pages/widgets/AnnouncementCard.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/services/AnnouncementServices.dart';
import 'package:madrasatymobile/viewmodel/announcement_viewmodel.dart';
import 'package:madrasatymobile/helpers/constants.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();

  @override
  String get screenName => 'Announcement Page';
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController? scrollController;
  String stdDiv_Global = 'Global';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLast = false;
  bool isLoaded = false;
  String buttonLabel = 'Global';
  TextEditingController _standardController = TextEditingController();
  TextEditingController _divisionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnnouncementViewModel>(
      init: AnnouncementViewModel(),
      builder: (controller) => Scaffold(
        key: scaffoldKey,
        appBar: TopBar(
            buttonHeroTag: string.announcement,
            title: stdDiv_Global + " Posts",
            child: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            }),
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: Stack(
          children: <Widget>[
            Visibility(
              visible: controller.isTeacher,
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  elevation: 12,
                  onPressed: () {
                    // kopenPageSlide(context, CreateAnnouncement(),
                    //     duration: Duration(milliseconds: 200));
                    Get.to(CreateAnnouncement());
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: controller.userType == UserType.Student
                    ? FloatingActionButton.extended(
                        label: Text(buttonLabel),
                        heroTag: 'abc',
                        elevation: 12,
                        onPressed: () async {
                          if (stdDiv_Global == 'Global') {
                            setState(() {
                              buttonLabel = stdDiv_Global;
                              stdDiv_Global = ((controller.user?.standard)! +
                                  (controller.user?.division)!.toUpperCase());
                            });
                          } else {
                            setState(() {
                              buttonLabel = stdDiv_Global;
                              stdDiv_Global = 'Global';
                            });
                          }

                          await controller
                              .onRefresh((controller.user?.divisionId)!);
                        },
                        icon: Icon(FontAwesomeIcons.globe),
                        backgroundColor: Colors.red,
                      )
                    : controller.userType == UserType.Teacher
                        ? FloatingActionButton.extended(
                            label: Text('Filter'),
                            heroTag: 'abc',
                            elevation: 12,
                            onPressed: () {
                              //Filter Posts Code Here
                              filterDialogBox(context, controller);
                            },
                            icon: Icon(Icons.filter_list),
                            backgroundColor: Colors.red,
                          )
                        : Container(),
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 700,
            ),
            child: RefreshIndicator(
              child: controller.announcements?.length == 0
                  ? controller.loading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          child: Center(
                            child: Text(
                              'No Posts available....!',
                              style: TextStyle(fontWeight: FontWeight.w600)
                                  .copyWith(fontSize: 25),
                            ),
                          ),
                          // color: Colors.red,
                        )
                  : ListView.builder(
                      addAutomaticKeepAlives: true,
                      cacheExtent: 10,
                      controller: scrollController,
                      itemCount: (controller.announcements?.length)! + 1,
                      itemBuilder: (context, index) {
                        if (index < (controller.announcements?.length)!) {
                          return AnnouncementCard(
                              announcement: controller.announcements?[index]);
                        } else {
                          return Center(
                            child: new Opacity(
                              opacity: controller.loading == true ? 1.0 : 0.0,
                              child: new SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  )),
                            ),
                          );
                        }
                      },
                    ),
              onRefresh: () async {
                await controller.onRefresh((controller.user?.divisionId)!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future filterDialogBox(BuildContext context, AnnouncementViewModel model) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            string.show_announcement_of,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                string.filter_announcement,
                // style: TextStyle(fontFamily: 'Subtitle'),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _standardController,
                  onChanged: (standard) {},
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  // decoration: InputDecoration(
                  //     hintText: "Master Pass",
                  //     hintStyle: TextStyle(fontFamily: "Subtitle"),
                  //     ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintStyle:
                        TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ).copyWith(
                    hintText: string.standard_hint,
                    labelText: string.standard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: _divisionController,
                  onChanged: (division) {},
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintStyle:
                        TextStyle(height: 1.5, fontWeight: FontWeight.w300),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  ).copyWith(
                    hintText: string.division_hint,
                    labelText: string.division,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(string.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  child: Text('Global'.toUpperCase()),
                  onPressed: () async {
                    setState(() {
                      stdDiv_Global = 'Global';
                    });
                    await model.onRefresh(
                        (Get.find<AnnouncementViewModel>().user?.divisionId)!);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton(
                  child: Text(string.filter),
                  onPressed: () async {
                    setState(() {
                      stdDiv_Global = _standardController.text.trim() +
                          _divisionController.text.trim().toUpperCase();
                    });
                    await model.onRefresh(
                        (Get.find<AnnouncementViewModel>().user?.divisionId)!);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
