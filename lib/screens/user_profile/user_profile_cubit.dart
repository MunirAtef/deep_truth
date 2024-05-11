
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend_logic/connect_request.dart';
import '../../backend_logic/interact_request.dart';
import '../../models/history_item_model.dart';
import '../../models/relation_model.dart';
import '../../models/response_model.dart';
import '../../models/user_model.dart';
import '../../resources/fixed_names.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(): super(UserProfileState());

  UserModel? userModel;
  RelationModel? relation;

  List<HistoryItemModel> publicHistory = [];
  bool historyLoading = true;
  bool relLoading = true;

  static UserProfileCubit getInstance(BuildContext context) =>
    BlocProvider.of<UserProfileCubit>(context);

  Future<void> getUserHistory() async {
    // historyLoading = true;
    // emit(UserProfileState(updateHistoryList: true));
    String? userId = userModel?.id;
    if (userId == null) return;

    ResponseModel<List<HistoryItemModel>> response
      = await InteractRequest.getInst().getAnotherUserHistory(userId);

    if (response.model == null) {
      Fluttertoast.showToast(msg: response.message);
    }
    publicHistory = response.model!;
    historyLoading = false;
    emit(UserProfileState(updateHistoryList: true));
  }

  Future<void> getRelation(UserModel userModel) async {
    this.userModel = userModel;

    ResponseModel<RelationModel?> resModel
      = await ConnectRequest.getInst().relation(userModel.id);
    relation = resModel.model;

    relLoading = false;
    emit(UserProfileState(updateRelation: true));
  }

  String getRequestText() {
    String? status = relation?.status;
    if (status == null) return "CONNECT";
    if (status == RequestStatus.accepted) return "CONNECTED";

    if (status == RequestStatus.pending) {
      if (relation?.meRequester() == true) return "PENDING";
      return "ACCEPT REQUEST";
    }
    return "CONNECT";
  }

  Future requestAction() async {
    ConnectRequest inst = ConnectRequest.getInst();
    String id = userModel!.id;
    String? status = relation?.status;

    relLoading = true;
    emit(UserProfileState(updateRelation: true));

    if (status == null) {
      await inst.sendRequest(id);
    } else if (status == RequestStatus.pending) {
      if (relation?.meRequester() == true) {
        await inst.undoRequest(id);
      } else {
        await inst.acceptRequest(id);
      }
    }

    await getRelation(userModel!);
  }

  bool clearAll() {
    userModel = null;
    relation = null;
    publicHistory.clear();

    historyLoading = true;
    relLoading = true;
    return true;
  }
}
