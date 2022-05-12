// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/pages/widgets/topbar.dart';
import 'package:madrasatymobile/viewmodel/auth_viewmodel.dart';
import 'package:madrasatymobile/viewmodel/profile_viewmodel.dart';

class ProfileView extends GetWidget<ProfileViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProfileViewModel controller = Get.find<ProfileViewModel>();

  selectImage(parentcontext) {
    return showDialog(
      context: parentcontext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create post .."),
          children: [
            SimpleDialogOption(
              child: Text("Photo with a camera"),
              onPressed: controller.handletakephoto,
            ),
            SimpleDialogOption(
              child: Text("Image from gallary"),
              onPressed: controller.handlechoosephoto,
            ),
            SimpleDialogOption(
              child: Text("cancel"),
              onPressed: () => Get.back(),
            )
          ],
        );
      },
    );
  }

  ImageProvider<Object> setImage() {
    if (Get.find<AuthViewModel>().user?.photoUrl != 'default') {
      return NetworkImage(
        (Get.find<AuthViewModel>().user?.photoUrl)!,
      );
    } else if (controller.path != 'default') {
      return FileImage(controller.image);
    } else {
      return AssetImage('assets/students.png');
    }
  }

  Widget buildProfilePhotoWidget(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      init: ProfileViewModel(),
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxHeight: 175, maxWidth: 175),
            child: Stack(
              children: <Widget>[
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: 'profileeee',
                      transitionOnUserGestures: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            height: MediaQuery.of(context).size.width / 2.5,
                            width: MediaQuery.of(context).size.width / 2.5,
                            image: setImage()),
                      ),
                    ),
                  ),
                ),
                controller.uploadimg == false
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 45,
                          width: 45,
                          child: Card(
                            elevation: 5,
                            color: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.black38,
                                size: 25,
                              ),
                              onPressed: () async {
                                selectImage(context);
                              },
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        right: 0,
                        bottom: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              child: Center(
                                child: Card(
                                  elevation: 5,
                                  color: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: IconButton(
                                    color: Colors.green,
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      controller.uploadImage();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              width: 45,
                              child: Card(
                                elevation: 5,
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: IconButton(
                                    color: Colors.red,
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () async {
                                      controller.clearImage();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          title: "Profile",
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Get.back();
          }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Save',
        elevation: 20,
        backgroundColor: Colors.red,
        onPressed: () async {
          _formKey.currentState?.save();
          if (_formKey.currentState!.validate()) {
            controller.setUserData();
          }
        },
        child: Icon(Icons.check),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                buildProfilePhotoWidget(context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ProfileFields(
                          labelText: 'Student/Teacher Name',
                          width: MediaQuery.of(context).size.width,
                          hintText: 'One which your parents gave',
                          onChanged: (name) {
                            controller.name = name;
                          },
                          controller:
                              TextEditingController(text: controller.name),
                        ),
                        ProfileFields(
                          isEditable: false,
                          labelText: 'Student 0r Teacher Roll no',
                          width: MediaQuery.of(context).size.width,
                          hintText: 'One which school gave',
                          onChanged: (id) {
                            controller.enrollNo = id;
                            ;
                          },
                          controller:
                              TextEditingController(text: controller.enrollNo),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ProfileFields(
                                isEditable: false,
                                labelText: 'Standard',
                                onChanged: (std) {
                                  // controller.standard = integ;
                                },
                                hintText: '',
                                controller: TextEditingController(
                                    text: controller.standard.toString()),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ProfileFields(
                                isEditable: false,
                                labelText: 'Division',
                                onChanged: (div) {
                                  // _division = div;
                                },
                                hintText: '',
                                controller: TextEditingController(
                                    text: controller.division.toString()),
                              ),
                            ),
                          ],
                        ),
                        ProfileFields(
                          width: MediaQuery.of(context).size.width,
                          hintText: 'Father\'s or Mother\'s Name',
                          labelText: 'Guardian Name',
                          onChanged: (guardianName) {
                            controller.guardianName = guardianName;
                          },
                          controller: TextEditingController(
                              text: controller.guardianName),
                        ),
                        Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // await _selectDate(context);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: IgnorePointer(
                                  child: ProfileFields(
                                      labelText: "Date of birth",
                                      textInputType: TextInputType.number,
                                      onChanged: (dob) {
                                        controller.dob = dob;
                                      },
                                      hintText: '',
                                      controller: TextEditingController(
                                        text: controller.dob,
                                      )
                                      // initialText: dateOfBirth == null
                                      //     ? ''
                                      //     : dateOfBirth
                                      //         .toLocal()
                                      //         .toString()
                                      //         .substring(0, 10),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ProfileFields(
                                // width: MediaQuery.of(context).size.width,
                                hintText: "your blood group",
                                labelText: "Blood Group",
                                onChanged: (bg) {
                                  controller.bloodGroup = bg;
                                },
                                controller: TextEditingController(
                                    text: controller.bloodGroup),
                              ),
                            ),
                          ],
                        ),
                        ProfileFields(
                          width: MediaQuery.of(context).size.width,
                          textInputType: TextInputType.number,
                          hintText: 'Your parents..',
                          labelText: 'Mobile No',
                          onChanged: (mobile_no) {
                            controller.mobileNo = mobile_no;
                          },
                          controller:
                              TextEditingController(text: controller.mobileNo),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileFields extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Function(String?)? onChanged;
  final double? width;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final bool isEditable;

  const ProfileFields(
      {@required this.labelText,
      this.hintText,
      this.onChanged,
      this.controller,
      this.textInputType,
      this.isEditable = true,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: width == null ? MediaQuery.of(context).size.width / 2.5 : width,
      child: TextFormField(
          enabled: isEditable,
          controller: controller,
          onSaved: onChanged,
          validator: (value) {
            if (value == null) {
              return 'asd';
            }
          },
          keyboardType: textInputType ?? TextInputType.text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            hintStyle: TextStyle(height: 1.5, fontWeight: FontWeight.w300),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          )),
    );
  }
}
