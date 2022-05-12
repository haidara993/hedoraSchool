import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const DOMAIN = 'http://10.0.2.2:5000/api/';
const LOGIN_ENDPOINT = DOMAIN + 'Auth/login';
const UPDATE_ENDPOINT = DOMAIN + 'Auth/update/';
const ANNOUNCEMENT_ENDPOINT = DOMAIN + 'Announcement/';
const ASSIGNMENT_ENDPOINT = DOMAIN + 'assignment/';
const UPLOAD_ENDPOINT = DOMAIN + 'upload/user/';
const UPLOAD_ASSIGNMENT_ENDPOINT = DOMAIN + 'upload/assignment/';
const UPLOAD_ANNOUNCEMENT_ENDPOINT = DOMAIN + 'upload/announcement/';

class HttpHelper {
  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {String? bearerToken}) async {
    return (await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {String? bearerToken}) async {
    return (await http.put(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> get(String url, {String? bearerToken}) async {
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'});
  }
}
