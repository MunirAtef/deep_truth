
import 'package:deep_truth/backend_logic/auth_request.dart';

class RelationModel {
  String recipientId;
  String requesterId;
  String status;
  int pendingDate;
  int? updatingDate;

  RelationModel({
    required this.recipientId,
    required this.requesterId,
    required this.status,
    required this.pendingDate,
    required this.updatingDate
  });

  factory RelationModel.fromJson(json) => RelationModel(
    recipientId: json["recipient_id"],
    requesterId: json["requester_id"],
    status: json["status"],
    pendingDate: json["pending_date"],
    updatingDate: json["updating_date"]
  );

  bool meRequester() =>
    requesterId == AuthRequest.inst.currentUser?.id;

}
