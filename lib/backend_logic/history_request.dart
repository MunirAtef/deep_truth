
import 'package:deep_truth/backend_logic/request.dart';
import 'package:dio/dio.dart';

import '../models/history_item_model.dart';

import '../resources/request_urls.dart';
import '../resources/fixed_names.dart';

class HistoryRequest extends Request {
  HistoryRequest._();
  static final HistoryRequest inst = HistoryRequest._();


  Future<List<HistoryItemModel>?> getHistoryData() async {
    Response response = await sendJson(
      url: RequestUrls.historyData,
      method: RequestMethods.get
    );

    if (response.statusCode == 200) {
      return HistoryItemModel.fromJsonList(response.data);
    }
    return null;
  }

  Future<int?> clearHistory() async {
    Response response = await sendJson(
      url: RequestUrls.clearHistory,
      method: RequestMethods.delete
    );

    if (response.statusCode == 200) {
      return (response.data as Map)["deletedFilesCount"];
    }

    return null;
  }
}
