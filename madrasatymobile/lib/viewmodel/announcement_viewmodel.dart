import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/enums/UserType.dart';
import 'package:madrasatymobile/enums/announcementType.dart';
import 'package:madrasatymobile/helpers/http_helper.dart';
import 'package:madrasatymobile/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/models/Announcement.dart';
import 'package:madrasatymobile/models/user.dart';
import 'package:madrasatymobile/services/AnnouncementServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnnouncementViewModel extends GetxController {
  UserType? _userType;
  UserType? get userType => _userType;

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  User? _user = new User();
  User? get user => _user;

  bool _isTeacher = false;
  bool get isTeacher => _isTeacher;

  String _postType = 'GLOBAL';
  String get postType => _postType;

  List<Announcement>? _announcements = [];
  List<Announcement>? get announcements => _announcements;

  AnnouncementServices _announcementServices = AnnouncementServices();

  AnnouncementType _announcementType = AnnouncementType.EVENT;
  AnnouncementType get announcementType => _announcementType;

  String path = 'default';
  late int userId;
  bool _uploadimg = false;
  bool get uploadimg => _uploadimg;

  XFile? _file;
  XFile? get file => _file;
  late File image;
  final ImagePicker _picker = ImagePicker();

  String? caption, standard, division;

  Future<void> handletakephoto() async {
    Get.back();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      path = pickedFile.path;
      this._file = pickedFile;
      _uploadimg = true;
      update();
    }
  }

  Future<void> handlechoosephoto() async {
    Get.back();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      path = pickedFile.path;
      this._file = pickedFile;
      _uploadimg = true;
      update();
    }
  }

  Future<void> clearImage() async {
    path = 'default';
    _uploadimg = false;
    update();
  }

  Future<String> uploadImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jwt = await pref.getString('jwt');
    String fileName = image.path;

    var request =
        http.MultipartRequest('POST', Uri.parse(UPLOAD_ANNOUNCEMENT_ENDPOINT));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    var res = await request.send();

    var result = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      path = result;

      _uploadimg = false;
      update();
    }

    return result;
  }

  getUser() async {
    _user = await SharedPreferencesHelper.getAccountFromLocal();
    userId = (_user?.id)!;

    update();
  }

  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getAnnouncements();
    getUserType();
    getUser();
  }

  void getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _userType = UserTypeHelper.getEnum((pref.getString('userType'))!);

    if (userType == UserType.Teacher) {
      _isTeacher = true;
    }
    update();
  }

  getAnnouncements() async {
    _loading.value = true;
    _announcements = await _announcementServices.getAnnouncements();
    _user = await SharedPreferencesHelper.getAccountFromLocal();
    _loading.value = false;
    update();
  }

  postAnnouncement() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (caption!.isEmpty || path.isEmpty) {
      Get.snackbar("unvailed data", "You Need to fill all the details");
    } else {
      uploadImage().then((value) async {
        var announcement = Announcement(
            userId: user?.id,
            userPhotoUrl: user?.photoUrl,
            displayName: user?.displayName,
            caption: caption,
            standardId: postType == 'SPECIFIC' ? int.parse(standard!) : 1,
            divisionId: postType == 'SPECIFIC' ? int.parse(division!) : 1,
            photoUrl: value,
            anouncementType: AnnouncementTypeHelper.getValue(announcementType),
            timestamp: "");

        var res = await _announcementServices.postAnnouncement(announcement);
        if (res == 200) {
          update();
          Get.snackbar("success", "Your data has been successfully updated");
          Get.back();
        }
      });
    }
  }

  setPostType(String type) {
    _postType = type;
    update();
  }

  onRefresh(int divId) async {
    _announcementServices.announcements?.clear();
    await getAnnouncements();
  }
}
