
import 'package:dio/dio.dart';

import '../resources/fixed_names.dart';
import 'auth_request.dart';


abstract class Request {
  String accessToken() => 'Bearer ${AuthRequest.inst.currentUser?.accessToken}';

  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      sendTimeout: const Duration(seconds: 100),
      validateStatus: (status) {
        return true;
      },
    )
  );


  Future<Response> sendJson({
    required String url,
    Map body = const {},
    bool provideToken = true,
    Map<String, dynamic>? queryPar,
    String method = RequestMethods.post
  }) async {
    Options options = Options(headers: {
      if (provideToken) "Authorization": accessToken()
    });

    switch (method) {
      case RequestMethods.get:
        return await dio.get(url, data: body, queryParameters: queryPar, options: options);
      case RequestMethods.delete:
        return await dio.delete(url, data: body, queryParameters: queryPar, options: options);
      case RequestMethods.patch:
        return await dio.patch(url, data: body, queryParameters: queryPar, options: options);
      default:
        return await dio.post(url, data: body, queryParameters: queryPar, options: options);
    }
  }

  String failedMessage(Response response) {
    try {
      String? message = response.data["message"];
      if (message == null || message.isEmpty) return "Request failed";
      message = message.replaceAll("_", " ");
      return message[0].toUpperCase() + message.substring(1).toLowerCase();
    } catch (_) {
      return"Request failed";
    }
  }
}

