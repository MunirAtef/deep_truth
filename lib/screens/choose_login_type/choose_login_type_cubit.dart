
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login/login_ui.dart';
import '../register/register_ui.dart';

class ChooseLoginTypeCubit extends Cubit<int> {
  ChooseLoginTypeCubit(): super(0);

  static ChooseLoginTypeCubit getInstance(BuildContext context) =>
    BlocProvider.of<ChooseLoginTypeCubit>(context);

  void navToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login()
      )
    );
  }

  void navToSignup(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Register()
      )
    );
  }

  Future<void> loginWithGoogle(BuildContext context) async {

  }
}
