import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:madrasatymobile/helpers/http_helper.dart';
import 'package:madrasatymobile/helpers/shared_preferences_helper.dart';
import 'dart:convert';
import 'package:madrasatymobile/main.dart';
import 'package:madrasatymobile/models/Announcement.dart';
import 'package:madrasatymobile/models/user.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementServices {
  User? user;
  List<Announcement>? announcements;

  Future<List<Announcement>?> getAnnouncements() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await SharedPreferencesHelper.getAccountFromLocal();

    var jwt = await prefs.getString("jwt");

    final Response response = await HttpHelper.get(
        ANNOUNCEMENT_ENDPOINT + user!.divisionId.toString(),
        bearerToken: jwt);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body).cast<Map<String, dynamic>>();
      announcements =
          res.map<Announcement>((json) => Announcement.fromJson(json)).toList();

      return announcements;
    } else {
      return [];
    }
  }

  Future<int> postAnnouncement(Announcement announcement) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "UserId": announcement.userId,
      "Caption": announcement.caption,
      "UserPhotoUrl": announcement.userPhotoUrl,
      "DisplayName": announcement.displayName,
      "DivisionId": announcement.divisionId,
      "StandardId": announcement.standardId,
      "TimeStamp": announcement.timestamp,
      "PhotoUrl": announcement.photoUrl,
      "AnnouncementType": announcement.anouncementType
    };
    // print(data);
    String? jwt = await prefs.getString("jwt");

    final Response response =
        await HttpHelper.post(ANNOUNCEMENT_ENDPOINT, data, bearerToken: jwt);

    return response.statusCode;
  }
}
