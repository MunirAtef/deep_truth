
import 'package:deep_truth/models/user_model.dart';
import 'package:deep_truth/screens/choose_login_type/choose_login_type_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend_logic/auth_request.dart';
import '../home_page/home_page_ui.dart';


class SplashCubit extends Cubit<int> {
  SplashCubit(): super(1);

  String appName = "Deep Truth";

  void init(context) async {
    NavigatorState navigator = Navigator.of(context);

    for (int i = 1; i <= appName.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      emit(i);
    }
    await Future.delayed(const Duration(seconds: 1));
    await checkLoginState(navigator);
  }

  Future<void> checkLoginState(NavigatorState navigator) async {
    AuthRequest instance = AuthRequest.inst;
    AppUserModel? loggedInUser = await instance.getLoggedInUser();
    if (loggedInUser == null) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const ChooseLoginType())
      );
      return;
    }

    await instance.refreshAccessToken();

    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage())
    );
  }
}
