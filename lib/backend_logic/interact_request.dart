
import 'package:deep_truth/models/history_item_model.dart';
import 'package:dio/dio.dart';

import '../models/response_model.dart';
import '../models/user_model.dart';
import '../resources/fixed_names.dart';
import '../resources/request_urls.dart';
import 'request.dart';

class InteractRequest extends Request {
  InteractRequest._();
  static InteractRequest? _instance;
  static InteractRequest getInst() {
    _instance ??= InteractRequest._();
    return _instance!;
  }

  Future<ResponseModel<List<UserModel>>> search(String searchTerm) async {
    Response response = await sendJson(
      url: RequestUrls.searchUsers,
      queryPar: {"search_term": searchTerm},
      method: RequestMethods.get
    );

    ResponseModel<List<UserModel>> responseModel = ResponseModel();

    if (response.statusCode == 200) {
      return responseModel.set(UserModel.fromJsonList(response.data));
    }
    return responseModel.failed(failedMessage(response));
  }

  Future<ResponseModel<List<HistoryItemModel>>> getAnotherUserHistory(String userId) async {
    Response response = await sendJson(
      url: RequestUrls.anotherUserHistory,
      queryPar: {"target_id": userId},
      method: RequestMethods.get
    );

    ResponseModel<List<HistoryItemModel>> responseModel = ResponseModel();

    if (response.statusCode == 200) {
      return responseModel.set(HistoryItemModel.fromJsonList(response.data));
    }

    return responseModel.failed(failedMessage(response));
  }
}
