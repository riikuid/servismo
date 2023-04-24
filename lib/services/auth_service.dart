import 'dart:convert';

import 'package:serpismotor2/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String baseUrl = 'http://dashboard.servismo.me/api';

  Future<UserModel> register({
    String? name,
    String? username,
    String? email,
    String? password,
  }) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password
    });
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      if (data['access_token'] != null) {
        user.token = 'Bearer ${data['access_token']}';
      } else {
        user.token = 'Invalid Token';
      }

      return user;
    } else {
      throw Exception('Failed to register user.');
    }
  }

  Future<UserModel> login({
    String? email,
    String? password,
  }) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'email': email, 'password': password});
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      if (data['access_token'] != null) {
        user.token = 'Bearer ${data['access_token']}';
      } else {
        user.token = 'Invalid Token';
      }

      return user;
    } else {
      throw Exception('Failed to register user.');
    }
  }
}