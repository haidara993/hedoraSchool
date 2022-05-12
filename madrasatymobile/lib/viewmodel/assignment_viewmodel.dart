import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/enums/UserType.dart';
import 'package:madrasatymobile/helpers/http_helper.dart';
import 'package:madrasatymobile/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/models/Assignment.dart';
import 'package:madrasatymobile/models/user.dart';
import 'package:madrasatymobile/services/AssignmentServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssignmentViewModel extends GetxController {
  UserType? _userType;
  UserType? get userType => _userType;

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  User? _user = new User();
  User? get user => _user;

  bool _isTeacher = false;
  bool get isTeacher => _isTeacher;

  List<Assignment>? _assignments = [];
  List<Assignment>? get assignments => _assignments;

  AssignmentServices _assignmentServices = AssignmentServices();

  String? title, description, details, subject;
  int? division, standard;

  String? caption;
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getAssignments();
    getUserType();
  }

  void getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _userType = UserTypeHelper.getEnum((pref.getString('userType'))!);

    if (userType == UserType.Teacher) {
      _isTeacher = true;
    }
    update();
  }

  XFile? _file;
  XFile? get file => _file;
  late File image;
  final ImagePicker _picker = ImagePicker();

  String path = 'default';
  late int userId;
  bool _uploadimg = false;
  bool get uploadimg => _uploadimg;

  handletakephoto() async {
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
        http.MultipartRequest('POST', Uri.parse(UPLOAD_ASSIGNMENT_ENDPOINT));
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

  postAssignment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (title!.isEmpty ||
        subject!.isEmpty ||
        standard != null ||
        division != null ||
        details!.isEmpty ||
        path.isEmpty) {
      Get.snackbar("unvailed data", "You Need to fill all the details");
    } else {
      Assignment assignment = Assignment(
        title: title,
        userId: userId,
        details: details,
        divisionId: division,
        standardId: standard,
        url: path,
        subject: subject,
      );

      int res = await _assignmentServices.postAssignment(assignment);
      if (res == 200) {
        Get.snackbar("success", "Your data has been successfully updated");
        update();
        Get.back();
      } else {
        Get.snackbar("success", "'All the fields are mandatory...'");
      }
    }
  }

  getAssignments() async {
    _loading.value = true;
    _assignments = await _assignmentServices.getAssignments();
    _user = await SharedPreferencesHelper.getAccountFromLocal();
    userId = (_user?.id)!;
    _loading.value = false;
    update();
  }

  onRefresh() async {
    _assignmentServices.assignments.clear();
    await getAssignments();
  }
}
