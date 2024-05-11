

import 'dart:io';


import 'package:deep_truth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend_logic/auth_request.dart';
import '../../backend_logic/profile_request.dart';
import '../../models/response_model.dart';
import '../../resources/pick_image.dart';
import '../choose_login_type/choose_login_type_ui.dart';
import '../home_page/home_page_ui.dart';
// import 'complete_registration.dart';
import 'register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(): super(RegisterState());

  static RegisterCubit getInstance(BuildContext context) =>
    BlocProvider.of<RegisterCubit>(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  bool isPassHidden = true;
  bool isConfirmHidden = true;
  bool isRegisterLoading = false;
  bool isComRegisterLoading = false;

  File? profilePicture;

  void updatePassVisibility() {
    isPassHidden = !isPassHidden;
    emit(RegisterState(updatePassVisibility: true));
  }

  void updateConfirmVisibility() {
    isConfirmHidden = !isConfirmHidden;
    emit(RegisterState(updateConfirmVisibility: true));
  }

  Future<void> registerWithEmail(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passController.text;
    String confirm = confirmController.text;

    bool validation = validate(name, email, password, confirm);
    if (!validation) return;

    NavigatorState navigator = Navigator.of(context);
    FocusScope.of(context).unfocus();

    isRegisterLoading = true;
    emit(RegisterState(updateRegisterLoading: true));

    ResponseModel<AppUserModel> responseModel =
      await AuthRequest.inst.signupWithEmail(name, email, password);

    if (responseModel.model == null) {
      isRegisterLoading = false;
      emit(RegisterState(updateRegisterLoading: true));
      Fluttertoast.showToast(msg: responseModel.message);
      return;
    }

    if (profilePicture != null) {
      String? imageRes = await ProfileRequest.inst.updatePicture(profilePicture!);
      if (imageRes != null) {
        Fluttertoast.showToast(msg: imageRes);
      }
    }

    clear();
    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()));
  }

  bool validate(String name, String email, String password, String confirm) {
    if (name.length < 4) {
      Fluttertoast.showToast(msg: "Too short name");
      return false;
    }
    if (!AuthRequest.inst.isValidEmail(email)) {
      Fluttertoast.showToast(msg: "The email is not valid");
      return false;
    }
    if (password.length < 8) {
      Fluttertoast.showToast(msg: "Password is too short");
      return false;
    }
    if (password != confirm) {
      Fluttertoast.showToast(msg: "Two passwords not matching");
      return false;
    }
    return true;
  }

  Future<bool> onWillPop() async {
    if (isRegisterLoading) return false;
    clear();
    return true;
  }

  void clear() {
    profilePicture = null;
    isRegisterLoading = false;
    nameController.clear();
    emailController.clear();
    passController.clear();
    confirmController.clear();
  }

  void backToLoginType(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ChooseLoginType()
      )
    );
  }

  void uploadImage(BuildContext context) async {
    File? pickedImage = await PickImage.pickImage(
      context: context,
      color: Colors.pink,
      onDelete: profilePicture == null? null: () {
        profilePicture = null;
        emit(RegisterState(updateUserImage: true));
      }
    );

    if (pickedImage != null) {
      profilePicture = pickedImage;
      emit(RegisterState(updateUserImage: true));
    }
  }



  void clearRegister() {
    emailController.clear();
    passController.clear();
    confirmController.clear();

    isPassHidden = true;
    isConfirmHidden = true;
    isRegisterLoading = false;
  }

  void clearCompRegister() {
    nameController.clear();
    isComRegisterLoading = false;
    profilePicture = null;
  }
}

