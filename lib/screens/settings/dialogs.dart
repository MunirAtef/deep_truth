
import 'package:flutter/material.dart';

import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_button.dart';
import '../../shared_widgets/custom_container.dart';
import '../../shared_widgets/custom_text_field.dart';

class ChangePasswordDialog extends StatefulWidget {
  final Future<bool> Function(String, String, String) onConfirm;
  const ChangePasswordDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController passController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool passHidden = true;
  bool newPassHidden = true;
  bool confirmPassHidden = true;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(vertical: 70),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        content: CustomContainer(
          width: width - 80,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "CHANGE PASSWORD",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19
                  ),
                ),

                CustomTextField(
                  controller: passController,
                  hint: "Current password",
                  prefix: const Icon(Icons.lock),
                  margin: const EdgeInsets.only(top: 15),
                  hideText: passHidden,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {passHidden = !passHidden;});
                    },
                    icon: passHidden?
                      const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                ),

                CustomTextField(
                  controller: newPassController,
                  hint: "New password",
                  prefix: const Icon(Icons.lock),
                  margin: const EdgeInsets.only(top: 15),
                  hideText: newPassHidden,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {newPassHidden = !newPassHidden;});
                    },
                    icon: newPassHidden?
                      const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                ),

                CustomTextField(
                  controller: confirmPassController,
                  hint: "Confirm password",
                  prefix: const Icon(Icons.lock),
                  margin: const EdgeInsets.only(top: 15),
                  hideText: confirmPassHidden,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {confirmPassHidden = !confirmPassHidden;});
                    },
                    icon: confirmPassHidden?
                      const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                ),

                StatefulBuilder(
                    builder: (context, setInternalState) {
                      return CustomButton(
                        text: "CONFIRM",
                        isLoading: isLoading,
                        margin: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                        color: MainColors.settingsPage,
                        onPressed: () async {
                          NavigatorState navigator = Navigator.of(context);
                          setInternalState(() { isLoading = true; });
                          bool result = await widget.onConfirm(
                            passController.text,
                            newPassController.text,
                            confirmPassController.text
                          );
                          setInternalState(() { isLoading = false; });
                          if (result) navigator.pop();
                        },
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class DeleteAccountDialog extends StatefulWidget {
  final Future<void> Function(String) onConfirm;
  const DeleteAccountDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController passController = TextEditingController();

  bool passHidden = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(vertical: 70),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),

        content: CustomContainer(
          width: width - 80,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "DELETE ACCOUNT",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: Text(
                    "Warning: if you continue, all your data will be removed forever.",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red
                    ),
                  ),
                ),

                CustomTextField(
                  controller: passController,
                  hint: "Password",
                  prefix: const Icon(Icons.lock),
                  margin: EdgeInsets.zero,
                  hideText: passHidden,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {passHidden = !passHidden;});
                    },
                    icon: passHidden?
                      const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )
                ),

                StatefulBuilder(
                  builder: (context, setInternalState) {
                    return CustomButton(
                      text: "CONFIRM",
                      isLoading: isLoading,
                      margin: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                      color: MainColors.settingsPage,
                      onPressed: () async {
                        setInternalState(() { isLoading = true; });
                        await widget.onConfirm(passController.text);
                        setInternalState(() { isLoading = false; });
                      },
                    );
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}





