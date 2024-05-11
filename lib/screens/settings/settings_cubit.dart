
import 'dart:io';

import 'package:deep_truth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backend_logic/auth_request.dart';

import '../../backend_logic/history_request.dart';
import '../../backend_logic/profile_request.dart';
import '../../resources/main_colors.dart';
import '../../resources/pick_image.dart';
import '../../shared_widgets/confirm_dialog.dart';
import '../../shared_widgets/custom_snake_bar.dart';
import '../../shared_widgets/input_dialog.dart';
import '../../shared_widgets/loading_dialog.dart';
import '../choose_login_type/choose_login_type_ui.dart';
import 'dialogs.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(): super(SettingsState());

  static getInstance(BuildContext context) =>
    BlocProvider.of<SettingsCubit>(context);

  UserModel currentUser = AuthRequest.inst.currentUser!;
  bool historyEnabled = true;
  bool historyPublic = false;

  void setup() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    historyEnabled = instance.getBool("enable_history") ?? true;
    historyPublic = instance.getString("access") == "public";
    emit(SettingsState(updateHistoryEnabling: true));
  }

  void changeName(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InputDialog(
        title: "UPDATE NAME",
        hint: "Enter the new name",
        color: MainColors.settingsPage,
        prefix: const Icon(Icons.person),
        defaultText: currentUser.name,
        onConfirm: (String name) async {
          String? result = await ProfileRequest.inst.updateName(name);
          Fluttertoast.showToast(msg: result ?? "Name updated");
          if (result == null) {
            currentUser.name = name;
            AuthRequest.inst.currentUser?.name = name;
            await AuthRequest.inst.saveUserData();

            emit(SettingsState(updateUserData: true));
          }
          return result == null;
        },
      )
    );
  }

  void changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordDialog(
        onConfirm: (String pass, String newPass, String confirmPass) async {
          if (pass.length < 8 || newPass.length < 8 || confirmPass.length < 8) {
            Fluttertoast.showToast(msg: "Any password must be at least 8 chars");
            return false;
          }
          if (newPass != confirmPass) {
            Fluttertoast.showToast(msg: "Two passwords not matching");
            return false;
          }

          String? result = await ProfileRequest.inst.updatePassword(pass, newPass);
          Fluttertoast.showToast(msg: result ?? "Password updated");
          return result == null;
        },
      )
    );
  }
  
  void logout(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);

    showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
          title: "LOGOUT",
          content: "Are you sure you want to logout from this account?",
          color: MainColors.settingsPage,
          onConfirm: () async {
            await AuthRequest.inst.logout();

            navigator.pop();
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ChooseLoginType()
              )
            );

            return false;
          },
        )
    );
  }

  void deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        onConfirm: (String password) async {
          NavigatorState navigator = Navigator.of(context);

          String? result = await ProfileRequest.inst.deleteAccount(password);
          Fluttertoast.showToast(msg: result ?? "Account deleted");
          if (result == null) {
            await AuthRequest.inst.logout();
            navigator.pop();
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ChooseLoginType()
              )
            );
          }
        }
      )
    );
  }

  void enableOrDisableHistory(bool value) async {
    historyEnabled = value;
    (await SharedPreferences.getInstance()).setBool("enable_history", value);
    emit(SettingsState(updateHistoryEnabling: true));
  }

  void setHistoryAccess(bool value) async {
    historyPublic = value;
    (await SharedPreferences.getInstance()).setString("access", value? "public": "private");
    emit(SettingsState(updateHistoryAccess: true));
  }

  void clearHistory(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: "CLEAR HISTORY",
        content: "Are you sure you want to clear the history?",
        color: MainColors.settingsPage,
        onConfirm: () async {
          int? result = await HistoryRequest.inst.clearHistory();
          String message = "History cleared";
          if (result == null) message = "Failed clear history";

          CustomSnackBar(context: context, subColor: MainColors.settingsPage)
            .show(message);

          return true;
        },
      )
    );

  }

  Future<void> changeProfilePicture(BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);

    File? pickedImage = await PickImage.pickImage(
      context: context,
      color: MainColors.settingsPage,
      onDelete: currentUser.profilePicture == null? null : () async {
        navigator.pop();
        await deleteProfilePicture(context);
      }
    );

    if (pickedImage != null) {
      showLoading(
        context: context,
        title: "UPDATING PROFILE PICTURE",
        color: MainColors.settingsPage,
        waitFor: () async {
          String? result = await ProfileRequest.inst.updatePicture(pickedImage);
          if (result != null) {
            Fluttertoast.showToast(msg: result);
            return;
          }
          emit(SettingsState(updateUserData: true));
        }
      );
    }
  }

  Future<void> deleteProfilePicture(BuildContext context) async {
    showLoading(
      context: context,
      title: "DELETING PROFILE PICTURE",
      color: MainColors.settingsPage,
      waitFor: () async {
        String? result = await ProfileRequest.inst.deletePicture();
        if (result != null) {
          Fluttertoast.showToast(msg: result);
          return;
        }
        emit(SettingsState(updateUserData: true));
      }
    );
  }
}
