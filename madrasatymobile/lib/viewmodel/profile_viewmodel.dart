import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:madrasatymobile/helpers/http_helper.dart';
import 'package:madrasatymobile/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileViewModel extends GetxController {
  User? _user = new User();
  User? get user => _user;

  String path = 'default';
  late int userId;
  bool _uploadimg = false;
  bool get uploadimg => _uploadimg;

  String? name, enrollNo, dob, guardianName, bloodGroup, mobileNo;
  int? standard, division;

  XFile? _file;
  XFile? get file => _file;
  late File image;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  ProfileViewModel() {
    getUser();
  }

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

    var request = http.MultipartRequest(
        'POST', Uri.parse(UPLOAD_ENDPOINT + userId.toString()));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    var res = await request.send();

    var result = await res.stream.bytesToString();
    if (res.statusCode == 200) {
      _user?.photoUrl = result;
      SharedPreferencesHelper.saveAcountToLocal(_user!);
      _uploadimg = false;
      update();
    }

    return result;
  }

  getUser() async {
    _user = await SharedPreferencesHelper.getAccountFromLocal();
    userId = (_user?.id)!;
    name = _user?.displayName;
    enrollNo = _user?.enrollNo;
    guardianName = _user?.guardianName;
    bloodGroup = _user?.bloodGroup;
    mobileNo = _user?.phoneNumber;
    standard = _user?.standardId;
    division = _user?.divisionId;
    dob = _user?.dob;
    update();
  }

  setUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (bloodGroup!.isEmpty ||
        name!.isEmpty ||
        enrollNo!.isEmpty ||
        dob!.isEmpty ||
        guardianName!.isEmpty ||
        mobileNo!.isEmpty) {
      Get.snackbar("unvailed data", "You Need to fill all the details");
    } else {
      print(name);
      Map<String, dynamic> json = {
        "photoUrl": _user?.photoUrl,
        "email": _user?.email,
        "divisionId": division,
        "standardId": standard,
        "displayName": name,
        "dob": dob,
        "guardianName": guardianName,
        "bloodGroup": bloodGroup,
        "phoneNumber": mobileNo,
        "isVerified": _user?.isVerified,
        "enrollNo": _user?.enrollNo
      };

      var bearerToken = pref.getString('jwt');
      var rs = await HttpHelper.put(
          UPDATE_ENDPOINT + (_user?.id.toString())!, json,
          bearerToken: bearerToken);

      if (rs.statusCode == 200) {
        var jsonObject = jsonDecode(rs.body);
        var account = User.fromJson(jsonObject);
        _user = account;

        SharedPreferencesHelper.saveAcountToLocal(account);
        Get.snackbar("success", "Your data has been successfully updated");
        update();
      }
    }
  }
}
