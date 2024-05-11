
import 'package:deep_truth/backend_logic/auth_request.dart';
import 'package:deep_truth/screens/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/font_family.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/screen_background.dart';
import '../../shared_widgets/user_info.dart';
import 'settings_cubit.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color subColor = MainColors.settingsPage;
    SettingsCubit cubit = SettingsCubit.getInstance(context);
    cubit.setup();

    return ScreenBackground(
      title: "SETTINGS",
      appBarColor: subColor,
      addBackIcon: false,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "ACCOUNT",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.handWriting
            ),
          ),

          const SizedBox(height: 10),

          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (ps, cs) => cs.updateUserData,
            builder: (context, state) {
              return SizedBox(
                // height: 84,
                child: UserInfo(
                  userModel: AuthRequest.inst.currentUser!,
                  color: subColor,
                ),
              );
            }
          ),

          const Divider(thickness: 2),

          SettingsButton(
            text: "CHANGE THE NAME",
            icon: Icons.person,
            onClick: () => cubit.changeName(context),
          ),

          SettingsButton(
            text: "CHANGE THE PASSWORD",
            icon: Icons.lock,
            onClick: () => cubit.changePassword(context),
          ),

          SettingsButton(
            text: "CHANGE THE PROFILE PICTURE",
            icon: Icons.image,
            onClick: () => cubit.changeProfilePicture(context),
          ),

          SettingsButton(
            text: "LOGOUT",
            icon: Icons.logout,
            onClick: () => cubit.logout(context),
          ),

          SettingsButton(
            text: "DELETE ACCOUNT",
            icon: Icons.delete,
            onClick: () => cubit.deleteAccount(context),
          ),

          const SizedBox(height: 10),
          const Divider(thickness: 4),
          const SizedBox(height: 10),

          const Text(
            "HISTORY",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: FontFamily.handWriting,
              // decoration: TextDecoration.underline
            ),
          ),

          const SizedBox(height: 5),


          SettingsButton(
            text: "SAVE TO HISTORY",
            icon: Icons.history,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onClick: null,
            leading: BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (ps, cs) => cs.updateHistoryEnabling,
              builder: (context, state) {
                return Switch(
                  value: cubit.historyEnabled,
                  activeColor: subColor,
                  onChanged: cubit.enableOrDisableHistory
                );
              }
            ),
          ),

          SettingsButton(
            text: "MAKE HISTORY PUBLIC",
            icon: Icons.public,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onClick: null,
            leading: BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (ps, cs) => cs.updateHistoryAccess,
              builder: (context, state) {
                return Switch(
                  value: cubit.historyPublic,
                  activeColor: subColor,
                  onChanged: cubit.setHistoryAccess
                );
              }
            ),
          ),

          SettingsButton(
            text: "CLEAR HISTORY",
            icon: Icons.delete,
            onClick: () => cubit.clearHistory(context),
          ),
        ],
      ),
    );
  }
}


class SettingsButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onClick;
  final Widget? leading;
  final EdgeInsetsGeometry? padding;


  const SettingsButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onClick,
    this.padding,
    this.leading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,

      child: Container(
        padding: padding ?? const EdgeInsets.all(10),
        margin: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(50, 50, 50, 1),
              Color.fromRGBO(100, 100, 100, 1),
              Colors.grey
            ]
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          children: [
            Icon(icon, color: MainColors.settingsPage),

            const SizedBox(width: 15),

            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),
            ),

            if (leading != null) ...[
              const Spacer(),
              leading!,
              // const SizedBox(width: 10)
            ]
          ],
        ),
      ),
    );
  }
}

