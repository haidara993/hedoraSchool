// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:madrasatymobile/models/Announcement.dart';
import 'package:madrasatymobile/pages/widgets/AnnouncementViewer.dart';
import 'package:madrasatymobile/viewmodel/announcement_viewmodel.dart';

class AnnouncementCard extends StatefulWidget {
  AnnouncementCard({@required this.announcement});

  final Announcement? announcement;

  @override
  _AnnouncementCardState createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  @override
  void initState() {
    super.initState();
    // getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AnnouncementViewModel>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        child: Card(
          elevation: 4,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                // color: Colors.red[200],
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Hero(
                      transitionOnUserGestures: false,
                      tag: (widget.announcement?.id).toString() + 'row',
                      child: Row(
                        children: <Widget>[
                          //User profile image section
                          // controller.loading == true
                          //     ?
                          CircleAvatar(
                            radius: 25.0,
                            backgroundImage: AssetImage('assets/teacher.png'),
                            backgroundColor: Colors.transparent,
                          )
                          // : CircleAvatar(
                          //     radius: 25.0,
                          //     backgroundImage: (widget
                          //                 .announcement?.userPhotoUrl)! ==
                          //             'default'
                          //         ?  AssetImage(
                          //             'assets/teacher.png')
                          //         : NetworkImage(
                          //             widget.announcement?.userPhotoUrl),
                          //     backgroundColor: Colors.transparent,
                          //   ),
                          ,
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //Announcement by section
                              Text(
                                controller.loading == true
                                    ? 'Loading...'
                                    : (widget.announcement?.displayName)!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              //TimeStamp section
                              Text(
                                // 'data',
                                (widget.announcement?.timestamp)!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Announcement Type section
                    Visibility(
                      visible: widget.announcement?.anouncementType == null
                          ? false
                          : true,
                      child: InkWell(
                        onTap: () {
                          print(widget.announcement?.timestamp.toString());
                          buildShowDialogBox(context);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          // color: Colors.redAccent,
                          elevation: 4,
                          child: CircleAvatar(
                            backgroundColor: ThemeData().canvasColor,
                            child: Text(
                              (widget.announcement?.anouncementType)
                                  .toString()
                                  .substring(
                                      (widget.announcement?.anouncementType)
                                              .toString()
                                              .indexOf('.') +
                                          1)
                                  .substring(0, 1),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //Announcemnet image Section
              Card(
                elevation: 4,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 300, minHeight: 0),
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: (widget.announcement?.id).toString() + 'photo',
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          Get.to(AnnouncementViewer(
                            announcement: widget.announcement,
                          ));
                        },
                        child: widget.announcement?.photoUrl == 'default'
                            ? Container(
                                height: 0,
                              )
                            : Image(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  (widget.announcement?.photoUrl)!,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              //Caption Section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 80, minHeight: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    transitionOnUserGestures: false,
                    tag: (widget.announcement?.id).toString() + 'caption',
                    child: Text(
                      (widget.announcement?.caption)!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  kopenPageBottom(BuildContext context, Widget page) {
    Navigator.of(context).push(
      CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext context) => page,
      ),
    );
  }
}

Future buildShowDialogBox(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Announcement Type"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  elevation: 4,
                  child: CircleAvatar(
                    backgroundColor: ThemeData().canvasColor,
                    child: Text(
                      'C',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text('CIRCULAR')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  elevation: 4,
                  child: CircleAvatar(
                    backgroundColor: ThemeData().canvasColor,
                    child: Text(
                      'E',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text('EVENT')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  elevation: 4,
                  child: CircleAvatar(
                    backgroundColor: ThemeData().canvasColor,
                    child: Text(
                      'A',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text('ACTIVITY')
              ],
            ),
          ],
        ),
        actions: <Widget>[],
      );
    },
  );
}
