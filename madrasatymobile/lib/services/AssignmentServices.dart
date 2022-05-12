import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:madrasatymobile/helpers/http_helper.dart';
import 'package:madrasatymobile/helpers/shared_preferences_helper.dart';
import 'package:madrasatymobile/main.dart';
import 'package:madrasatymobile/models/Assignment.dart';
import 'package:madrasatymobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentServices {
  User? user;
  List<Assignment> assignments = [];

  Future<int> postAssignment(Assignment assignment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "UserId": assignment.userId,
      "Title": assignment.title,
      "Details": assignment.details,
      "DivisionId": assignment.divisionId,
      "StandardId": assignment.standardId,
      "TimeStamp": assignment.timeStamp,
      "Url": assignment.url,
      "Subject": assignment.subject
    };
    // print(data);
    String? jwt = await prefs.getString("jwt");

    final Response response =
        await HttpHelper.post(ASSIGNMENT_ENDPOINT, data, bearerToken: jwt);

    return response.statusCode;
  }

  Future<List<Assignment>> getAssignments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await SharedPreferencesHelper.getAccountFromLocal();

    var jwt = await prefs.getString("jwt");

    final Response response = await HttpHelper.get(
        ASSIGNMENT_ENDPOINT + user!.divisionId.toString(),
        bearerToken: jwt);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body).cast<Map<String, dynamic>>();
      assignments =
          res.map<Assignment>((json) => Assignment.fromJson(json)).toList();

      return assignments;
    } else {
      return [];
    }
  }
}
