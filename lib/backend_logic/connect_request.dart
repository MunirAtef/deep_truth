
import 'package:deep_truth/models/relation_model.dart';
import 'package:deep_truth/models/user_model.dart';
import 'package:dio/dio.dart';

import '../models/con_req_model.dart';
import '../models/response_model.dart';
import '../resources/fixed_names.dart';
import '../resources/request_urls.dart';
import 'request.dart';

class ConnectRequest extends Request {
  ConnectRequest._();
  static ConnectRequest? _inst;
  static ConnectRequest getInst() {
    _inst ??= ConnectRequest._();
    return _inst!;
  }

  Future<String?> sendRequest(String recipientId) async {
    Response response = await sendJson(
      url: RequestUrls.sendRequest,
      queryPar: {"recipient": recipientId}
    );

    if (response.statusCode == 200) return null;
    return failedMessage(response);
  }

  Future<String?> acceptRequest(String requesterId) async {
    Response response = await sendJson(
      url: RequestUrls.acceptRequest,
      queryPar: {"requester": requesterId}
    );

    if (response.statusCode == 200) return null;
    return failedMessage(response);
  }

  Future<String?> removeRequest(String requesterId) async {
    Response response = await sendJson(
      url: RequestUrls.removeRequest,
      queryPar: {"requester": requesterId}
    );

    if (response.statusCode == 200) return null;
    return failedMessage(response);
  }

  Future<String?> undoRequest(String recipientId) async {
    Response response = await sendJson(
      url: RequestUrls.undoRequest,
      queryPar: {"recipient": recipientId}
    );

    if (response.statusCode == 200) return null;
    return failedMessage(response);
  }

  Future<ResponseModel<List<ConReqModel>>> requests({required bool inbound}) async {
    Response response = await sendJson(
      url: inbound? RequestUrls.inboundRequests: RequestUrls.outboundRequests,
      method: RequestMethods.get
    );

    ResponseModel<List<ConReqModel>> responseModel = ResponseModel();

    if (response.statusCode == 200) {
      return responseModel.set(ConReqModel.fromJsonList(response.data));
    }
    return responseModel.failed(failedMessage(response));
  }

  Future<ResponseModel<List<UserModel>>> connection() async {
    Response response = await sendJson(
      url: RequestUrls.connections,
      method: RequestMethods.get
    );

    ResponseModel<List<UserModel>> responseModel = ResponseModel();

    if (response.statusCode == 200) {
      return responseModel.set(UserModel.fromJsonList(response.data));
    }
    return responseModel.failed(failedMessage(response));
  }

  Future<ResponseModel<RelationModel?>> relation(String userId) async {
    Response response = await sendJson(
      url: RequestUrls.relation,
      queryPar: {"target": userId},
      method: RequestMethods.get
    );

    ResponseModel<RelationModel?> responseModel = ResponseModel();

    if (response.statusCode == 200) {
      return responseModel.set(RelationModel.fromJson(response.data));
    } else if (response.statusCode == 202) {
      return responseModel.set(null);
    }
    return responseModel.failed(failedMessage(response));
  }
}
