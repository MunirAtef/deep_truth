
import 'package:deep_truth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend_logic/auth_request.dart';
import '../../models/response_model.dart';
import '../choose_login_type/choose_login_type_ui.dart';
import '../home_page/home_page_ui.dart';



class LoginState {
  bool passHidden;
  bool loadingEmail;
  bool loadingGoogle;

  LoginState({
    this.passHidden = true,
    this.loadingEmail = false,
    this.loadingGoogle = false
  });

  LoginState change({
    bool? passHidden,
    bool? loadingEmail,
    bool? loadingGoogle
  }) {
    return LoginState(
      passHidden: passHidden ?? this.passHidden,
      loadingEmail: loadingEmail ?? this.loadingEmail,
      loadingGoogle: loadingGoogle ?? this.loadingGoogle
    );
  }
}


class LoginCubit extends Cubit<LoginState> {
  LoginCubit(): super(LoginState());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void changePassVisibility() {
    emit(state.change(passHidden: !state.passHidden));
  }

  Future<void> loginWithEmail(BuildContext context) async {
    String email = emailController.text.trim();
    String pass = passController.text;
    NavigatorState navigator = Navigator.of(context);

    AuthRequest instance = AuthRequest.inst;

    if (!instance.isValidEmail(email)) return toastEnd("Invalid email");
    if (pass.length < 8) return toastEnd("Too short password");

    FocusScope.of(context).unfocus();
    emit(state.change(loadingEmail: true, loadingGoogle: false));
    ResponseModel<AppUserModel> res = await instance.loginWithEmail(email, pass);

    if (res.model != null) {
      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage()
      ));
    } else {
      Fluttertoast.showToast(msg: res.message);
    }

    emit(state.change(loadingEmail: false, loadingGoogle: false));
  }


  void backToLoginType(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChooseLoginType()
      )
    );
  }

  void toastEnd(String msg) => Fluttertoast.showToast(msg: msg);
}



