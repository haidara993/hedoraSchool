import 'dart:convert';
import 'dart:io';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:madrasatymobile/enums/announcementType.dart';
import 'package:madrasatymobile/main.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/announcement_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:madrasatymobile/helpers/constants.dart';
import 'package:http/http.dart' as http;

class CreateAnnouncement extends StatefulWidget {
  CreateAnnouncement({Key? key}) : super(key: key);

  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  String path = 'default';

  AnnouncementType announcementType = AnnouncementType.EVENT;

  FocusNode _focusNode = new FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPosting = false;
  Color postTypeFontColor = Colors.black;
  bool isReadyToPost = false;

  @override
  void initState() {
    super.initState();
  }

  // floatingButtonPressed(
  //     AnnouncementPageModel model, BuildContext context) async {
  //   if (file != null) {
  //     // await compressImage();
  //     path = await uploadImage(file);
  //     print(path);
  //     kbackBtn(context);
  //   }
  //   var announcement = Announcement(
  //       userId: user.id,
  //       userPhotoUrl: user.photoUrl,
  //       displayName: user.displayName,
  //       caption: _captionController.text,
  //       standardId:
  //           postType == 'SPECIFIC' ? int.parse(_standardController.text) : 0,
  //       divisionId:
  //           postType == 'SPECIFIC' ? int.parse(_divisionController.text) : 0,
  //       photoUrl: path,
  //       anouncementType: AnnouncementTypeHelper.getValue(announcementType),
  //       timestamp: "");
  //   if (postType == 'SPECIFIC') {
  //     if (_standardController.text.trim() == '' ||
  //         _divisionController.text.trim() == '') {
  //       _scaffoldKey.currentState.showSnackBar(
  //           ksnackBar(context, 'Please Specify Class and Division'));
  //     } else {
  //       int res = await model.postAnnouncement(announcement);
  //       if (res == 200) {
  //         kbackBtn(context);
  //       }
  //     }
  //   } else {
  //     int res = await model.postAnnouncement(announcement);
  //     if (res == 200) {
  //       kbackBtn(context);
  //     }
  //   }
  // }

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create post .."),
          children: [
            SimpleDialogOption(
              child: Text("Photo with a camera"),
              onPressed: Get.find<AnnouncementViewModel>().handletakephoto,
            ),
            SimpleDialogOption(
              child: Text("Image from gallary"),
              onPressed: Get.find<AnnouncementViewModel>().handlechoosephoto,
            ),
            SimpleDialogOption(
              child: Text("cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  // compressImage() async {
  //   Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
  //   final compressedImageFile = File(path)
  //     .writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     file = compressedImageFile;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    postTypeFontColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return GetBuilder<AnnouncementViewModel>(
      builder: (controller) => Scaffold(
        appBar: TopBar(
          onTitleTapped: () {},
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            // if (!isPosting) kbackBtn(context);
            Get.back();
          },
          title: 'Create Announcement',
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // if (isReadyToPost) floatingButtonPressed(model, context);
            _formKey.currentState?.save();
            if (_formKey.currentState!.validate()) {
              controller.postAnnouncement();
            }
          },
          backgroundColor:
              isReadyToPost ? Theme.of(context).primaryColor : Colors.blueGrey,
          child: controller.loading == true
              ? SpinKitDoubleBounce(
                  color: Colors.white,
                  size: 20,
                )
              : Icon(Icons.check),
        ),
        body: InkWell(
          // splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _focusNode.unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // height: 165,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'this post is for',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: RawMaterialButton(
                                    elevation: 0,
                                    constraints: BoxConstraints(minHeight: 50),
                                    child: Text(
                                      'GLOBAL POST',
                                      style: TextStyle(
                                        color: controller.postType == 'GLOBAL'
                                            ? Colors.white
                                            : postTypeFontColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.setPostType('GLOBAL');
                                    },
                                    fillColor: controller.postType == 'GLOBAL'
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                                Expanded(
                                  child: RawMaterialButton(
                                    elevation: 0,
                                    constraints: BoxConstraints(minHeight: 50),
                                    child: Text(
                                      'SPECIFIC',
                                      style: TextStyle(
                                        color: controller.postType == 'SPECIFIC'
                                            ? Colors.white
                                            : postTypeFontColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.setPostType('SPECIFIC');
                                    },
                                    fillColor: controller.postType == 'SPECIFIC'
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          controller.postType == 'SPECIFIC'
                              ? SizedBox(
                                  height: 5,
                                )
                              : Container(),
                          controller.postType == 'SPECIFIC'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      // width: MediaQuery.of(context).size.width / 2.2,
                                      child: TextFormField(
                                        enabled: !isPosting,
                                        onSaved: (newValue) {
                                          controller.standard = newValue;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'asd';
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          hintStyle: TextStyle(
                                              height: 1.5,
                                              fontWeight: FontWeight.w300),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                        ).copyWith(
                                          hintText: string.standard_hint,
                                          labelText: string.standard,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      // width: MediaQuery.of(context).size.width / 2.2,
                                      child: TextFormField(
                                        enabled: !isPosting,
                                        onSaved: (newValue) {
                                          controller.division = newValue;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'asd';
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          hintStyle: TextStyle(
                                              height: 1.5,
                                              fontWeight: FontWeight.w300),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                        ).copyWith(
                                          hintText: string.standard_hint,
                                          labelText: string.division,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    controller.postType == 'SPECIFIC'
                        ? SizedBox(
                            height: 5,
                          )
                        : Container(),
                    Container(
                      // height: 60,
                      // color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'EVENT',
                                style: TextStyle(
                                  color:
                                      announcementType == AnnouncementType.EVENT
                                          ? Colors.white
                                          : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (controller.loading == false)
                                    announcementType = AnnouncementType.EVENT;
                                });
                              },
                              color: announcementType == AnnouncementType.EVENT
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'CIRCULAR',
                                style: TextStyle(
                                  color: announcementType ==
                                          AnnouncementType.CIRCULAR
                                      ? Colors.white
                                      : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (controller.loading == false)
                                    announcementType =
                                        AnnouncementType.CIRCULAR;
                                });
                              },
                              color:
                                  announcementType == AnnouncementType.CIRCULAR
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Text(
                                'ACTIVITY',
                                style: TextStyle(
                                  color: announcementType ==
                                          AnnouncementType.ACTIVITY
                                      ? Colors.white
                                      : postTypeFontColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (controller.loading == false)
                                    announcementType =
                                        AnnouncementType.ACTIVITY;
                                });
                              },
                              color:
                                  announcementType == AnnouncementType.ACTIVITY
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 300, minHeight: 0),
                      child: controller.path == 'default'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  height: 100,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Icon(FontAwesomeIcons.camera),
                                  onPressed: () async {
                                    selectImage(context);
                                  },
                                ),
                              ],
                            )
                          : Card(
                              elevation: 4,
                              child: Container(
                                // constraints:
                                //     BoxConstraints(maxHeight: 300, minHeight: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            controller.image,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -0,
                                      bottom: -0,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: MaterialButton(
                                          minWidth: 20,
                                          height: 10,
                                          onPressed: () {
                                            controller.clearImage();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      // color: Colors.blueAccent.withOpacity(0.5),
                      child: TextFormField(
                        onSaved: (newValue) {
                          controller.caption = newValue;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'asd';
                          }
                        },
                        enabled: !isPosting,
                        focusNode: _focusNode,
                        maxLength: null,
                        onChanged: (caption) {
                          setState(() {
                            isReadyToPost = caption == '' ? false : true;
                          });
                        },
                        maxLines: 50,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintStyle: TextStyle(
                              height: 1.5, fontWeight: FontWeight.w300),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ).copyWith(
                          hintText: string.type_your_stuff_here,
                          labelText: string.caption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
