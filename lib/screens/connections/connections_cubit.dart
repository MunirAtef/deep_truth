
import 'package:deep_truth/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend_logic/connect_request.dart';
import '../../models/user_model.dart';
import 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  ConnectionsCubit(): super(ConnectionsState());

  static ConnectionsCubit getInstance(BuildContext context) =>
    BlocProvider.of<ConnectionsCubit>(context);

  List<UserModel> connections = [];
  bool connectionsLoading = true;

  Future<void> getConnections() async {
    ResponseModel<List<UserModel>> response
      = await ConnectRequest.getInst().connection();

    connections = response.model ?? [];
    connectionsLoading = false;
    emit(ConnectionsState());
  }
}
