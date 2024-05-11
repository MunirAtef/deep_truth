
import 'user_model.dart';

class ConReqModel {
  UserModel user;
  String status;
  int pendingDate;
  int? updatingDate;

  ConReqModel({
    required this.user,
    required this.status,
    required this.pendingDate,
    required this.updatingDate,
  });

  factory ConReqModel.fromJson(json) => ConReqModel(
    user: UserModel.fromJson(json["user"]),
    status: json["status"],
    pendingDate: json["pending_date"],
    updatingDate: json["updating_date"],
  );

  static List<ConReqModel> fromJsonList(json) =>
    (json as List).map((e) => ConReqModel.fromJson(e)).toList();
}

