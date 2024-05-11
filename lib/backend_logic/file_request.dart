
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/face_model.dart';
import '../resources/fixed_names.dart';
import '../resources/request_urls.dart';
import 'request.dart';

class FileRequest extends Request {
  FileRequest._();
  static final FileRequest inst = FileRequest._();

  Future<Uint8List?> getFileBytes(String filename) async {
    Response response = await dio.get(
      RequestUrls.getFile,
      queryParameters: {"filename": filename},
      options: Options(
        headers: {
          "Authorization": accessToken()
        },
        responseType: ResponseType.bytes
      )
    );

    if (response.statusCode == 200) return response.data;
    return null;
  }

  Future<List<FaceModel>?> uploadFile({
    required File file,
    void Function(int, int)? onSend,
    required int th
  }) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    bool save = instance.getBool("enable_history") ?? true;
    String access = instance.getString("access") ?? "public";

    FormData formData = FormData.fromMap({
      'ftc': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(".").last),
    });

    Response response = await dio.post(
      RequestUrls.checkFile,
      data: formData,
      queryParameters: {"save": save? "true": null, "access": access, "th": th},
      onSendProgress: onSend,
      options: Options(
        headers: {
          "Content-Type": "multipart/from-data",
          "Authorization": accessToken()
        }
      )
    );

    return response.statusCode == 200?
      FaceModel.fromJsonList(response.data): null;
  }

  Future<bool> deleteHistoryFile(String filename) async {
    Response response = await sendJson(
      url: RequestUrls.deleteFile,
      queryPar: {"filename": filename},
      method: RequestMethods.delete
    );

    return response.statusCode == 200;
  }
}

