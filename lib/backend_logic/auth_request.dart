
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/response_model.dart';
import '../models/user_model.dart';
import '../resources/request_urls.dart';
import 'request.dart';


class AuthRequest extends Request {
  AuthRequest._();
  static final AuthRequest inst = AuthRequest._();

  AppUserModel? currentUser;


  Future<AppUserModel?> getLoggedInUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? user = sharedPreferences.getString("user");
    if (user == null) return null;
    currentUser = AppUserModel.fromJson(json.decode(user));
    return currentUser;
  }

  Future<void> saveUserData() async {
    if (currentUser == null) return;
    Map userData = currentUser!.toJson();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("user", json.encode(userData));
  }


  Future<ResponseModel<AppUserModel>> signupWithEmail(name, email, password) async {
    ResponseModel<AppUserModel> responseModel = ResponseModel();

    Response response = await sendJson(
      url: RequestUrls.signup,
      body: {"name": name, "email": email, "password": password},
      provideToken: false,
    );

    if (response.statusCode == 200) {
      currentUser = AppUserModel.fromJson(response.data);
      await saveUserData();

      return responseModel.set(currentUser);
    }

    return responseModel.failed(failedMessage(response));
  }


  Future<ResponseModel<AppUserModel>> loginWithEmail(email, password) async {
    ResponseModel<AppUserModel> responseModel = ResponseModel();

    Response response = await sendJson(
      url: RequestUrls.login,
      body: {"email": email, "password": password},
      provideToken: false
    );

    if (response.statusCode == 200) {
      currentUser = AppUserModel.fromJson(response.data);
      await saveUserData();
      return responseModel.set(currentUser);
    }
    return responseModel.failed(failedMessage(response));
  }

  Future<void> refreshAccessToken() async {
    if (currentUser == null) return;

    Response response = await sendJson(
      url: RequestUrls.refreshAccessToken,
      body: {"refresh_token": currentUser?.refreshToken}
    );

    if (response.statusCode != 200) return;

    String newAccessToken = response.data;
    currentUser?.accessToken = newAccessToken;
  }

  Future<void> logout() async {
    currentUser = null;
    await (await SharedPreferences.getInstance()).remove("user");
  }

  static loginWithGoogle(BuildContext context) {

  }

  bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false;
    }

    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(email);
  }
}
