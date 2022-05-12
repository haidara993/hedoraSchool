import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:madrasatymobile/models/Assignment.dart';
import 'package:madrasatymobile/pages/widgets/AssignmentBottomSheet.dart';
import 'package:madrasatymobile/pages/widgets/ColumnReusableCardButton.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/assignment_viewmodel.dart';

class AssignmentsPage extends StatefulWidget {
  AssignmentsPage({Key? key, this.standard = ''}) : super(key: key) {
    // setCurrentScreen();
  }

  final String standard;

  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();

  @override
  String get screenName => 'Assignment' + 'Page';
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  ScrollController? scrollController;
  String? stdDiv_Global;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (Get.find<AssignmentViewModel>().loading == true) {
      if (scrollController?.position.pixels ==
          scrollController?.position.maxScrollExtent) {
        // setState(() => _isLoading = true);
        Get.find<AssignmentViewModel>().getAssignments();
        // scaffoldKey.currentState.widget
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssignmentViewModel>(
      init: AssignmentViewModel(),
      builder: (controller) => Scaffold(
        key: _scaffoldKey,
        appBar: TopBar(
            title: 'Assignment',
            child: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            }),
        floatingActionButton: Visibility(
          visible: controller.isTeacher,
          child: FloatingActionButton(
            onPressed: () {
              // buildShowDialogBox(context);
              // showAboutDialog(context: context);
              showModalBottomSheet(
                elevation: 10,
                isScrollControlled: true,
                context: context,
                builder: (context) => AssignmentBottomSheet(),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 700,
            ),
            child: RefreshIndicator(
              displacement: 10,
              child: stdDiv_Global == 'N.A'
                  ? Container(
                      child: Center(
                        child: Text(
                            '''Sorry, You Don\'t have any Class associated with you....!
If you are a parent then go to childrens section to check assignments''',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontWeight: FontWeight.w600).copyWith(
                              fontSize: 25,
                            )),
                      ),
                    )
                  : controller.loading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.assignments?.length == 0
                          ? Container(
                              child: Center(
                                child: Text(
                                  'No Assignments available....!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.w600)
                                      .copyWith(fontSize: 25),
                                ),
                              ),
                            )
                          : ListView.builder(
                              addAutomaticKeepAlives: true,
                              cacheExtent: 10,
                              controller: scrollController,
                              itemCount: (controller.assignments?.length)! + 1,
                              itemBuilder: (context, i) {
                                if (i < (controller.assignments?.length)!) {
                                  Assignment assignment =
                                      controller.assignments![i];
                                  // print(assignment.id);
                                  return ColumnReusableCardButton(
                                    tileColor: Colors.blue,
                                    label: assignment.title,
                                    icon: FontAwesomeIcons.bookOpen,
                                    onPressed: () {
                                      // showModalBottomSheet(
                                      //   elevation: 10,
                                      //   isScrollControlled: true,
                                      //   context: context,
                                      //   builder: (context) =>
                                      //       AssignmentDetailBottomSheet(
                                      //     assignment: assignment,
                                      //   ),
                                      // );
                                    },
                                    height: 70,
                                  );
                                } else {
                                  return Center(
                                    child: new Opacity(
                                      opacity: controller.loading == true
                                          ? 1.0
                                          : 0.0,
                                      child: new SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: new CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
              onRefresh: () async {
                await controller.onRefresh();
              },
            ),
          ),
        ),
      ),
    );
  }
}
