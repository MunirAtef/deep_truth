
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend_logic/interact_request.dart';
import '../../models/response_model.dart';
import '../../models/user_model.dart';
import 'search_users_state.dart';

class SearchUsersCubit extends Cubit<SearchUsersState> {
  SearchUsersCubit(): super(SearchUsersState());

  static SearchUsersCubit getInstance(BuildContext context) =>
    BlocProvider.of<SearchUsersCubit>(context);

  List<UserModel> users = [];
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  Future<void> search() async {
    isLoading = true;
    emit(SearchUsersState(updateSearchList: true));
    String searchTerm = searchController.text.trim();

    ResponseModel<List<UserModel>> resModel
      = await InteractRequest.getInst().search(searchTerm);

    users = resModel.model ?? [];
    if (resModel.model == null) {
      Fluttertoast.showToast(msg: resModel.message);
    }

    isLoading = false;
    emit(SearchUsersState(updateSearchList: true));
  }
}
