import 'dart:convert';

import 'package:madrasatymobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static saveAcountToLocal(User accountModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var rs = await pref.setString('login', jsonEncode(accountModel));
  }

  static Future<User?> getAccountFromLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var account = pref.getString('login');
    if (account != null) {
      return User.fromJson(jsonDecode(account));
    }
    return null;
  }

  static deleteAccountFromLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var rs = await pref.remove('login');
  }
}
