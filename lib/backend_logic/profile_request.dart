
import 'dart:io';

import '../resources/request_urls.dart';
import 'auth_request.dart';
import 'request.dart';
import 'package:dio/dio.dart';

class ProfileRequest extends Request {
  ProfileRequest._();
  static final ProfileRequest inst = ProfileRequest._();


  Future<String?> updateName(String newName) async {
    Response response = await sendJson(
      url: RequestUrls.updateName,
      body: {
        "name": newName
      }
    );

    return response.statusCode == 200? null: failedMessage(response);
  }

  Future<String?> updatePassword(String currentPass, String newPass) async {
    Response response = await sendJson(
        url: RequestUrls.updatePassword,
        body: {
          "password": currentPass,
          "new_password": newPass
        }
    );

    return response.statusCode == 200? null: failedMessage(response);
  }

  Future<String?> updatePicture(File file) async {
    FormData formData = FormData.fromMap({
      'profile_picture': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(".").last),
    });

    Response response = await dio.post(
      RequestUrls.updatePicture,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/from-data",
          "Authorization": accessToken()
        }
      )
    );

    if (response.statusCode == 200) {
      AuthRequest.inst.currentUser?.profilePicture = response.data;
      await AuthRequest.inst.saveUserData();
    }

    return response.statusCode == 200? null: failedMessage(response);
  }

  Future<String?> deletePicture() async {
    Response response = await sendJson(url: RequestUrls.deletePicture);

    if (response.statusCode == 200) {
      AuthRequest.inst.currentUser?.profilePicture = null;
      await AuthRequest.inst.saveUserData();
    }

    return response.statusCode == 200? null: failedMessage(response);
  }

  Future<String?> deleteAccount(String password) async {
    Response response = await sendJson(
      url: RequestUrls.deleteAccount,
      body: {"password": password}
    );

    return response.statusCode == 200? null: failedMessage(response);
  }
}
