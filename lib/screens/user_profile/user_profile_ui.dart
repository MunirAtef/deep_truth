
import 'package:deep_truth/models/user_model.dart';
import 'package:deep_truth/screens/history/history_item/history_image.dart';
import 'package:deep_truth/screens/user_profile/user_profile_state.dart';
import 'package:deep_truth/shared_widgets/loading.dart';
import 'package:deep_truth/shared_widgets/no_result.dart';
import 'package:deep_truth/shared_widgets/screen_background.dart';
import 'package:deep_truth/shared_widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/font_family.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_button.dart';
import 'user_profile_cubit.dart';

class UserProfile extends StatelessWidget {
  final UserModel model;
  const UserProfile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color subColor = MainColors.userProfilePage;
    UserProfileCubit cubit = UserProfileCubit.getInstance(context);
    cubit.getRelation(model);
    cubit.getUserHistory();

    return WillPopScope(
      onWillPop: () async => cubit.clearAll(),

      child: ScreenBackground(
        title: "USER PROFILE",
        appBarColor: subColor,
        onBackIconPressed: cubit.clearAll,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfo(userModel: model, color: subColor, clipBottom: false),

              BlocBuilder<UserProfileCubit, UserProfileState>(
                buildWhen: (ps, cs) => cs.updateRelation,
                builder: (context, state) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 40,
                        margin: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // MainColors.appColorDark,
                              Colors.black,
                              Colors.grey
                            ]
                          ),
                        ),
                        child: Text(
                          "CONNECTED",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ),

                      CustomButton(
                        onPressed: cubit.requestAction,
                        text: cubit.relLoading? "LOADING...": cubit.getRequestText(),
                        color: subColor,
                        margin: EdgeInsets.zero,
                        leading: const Icon(Icons.add_box, color: Colors.white),
                        isLoading: cubit.relLoading,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                        ),
                      ),
                    ],
                  );
                }
              ),

              const Divider(thickness: 2),

              const SizedBox(height: 15),

              const Text(
                "PUBLIC HISTORY",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: FontFamily.handWriting
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<UserProfileCubit, UserProfileState>(
                  buildWhen: (ps, cs) => cs.updateHistoryList,
                  builder: (context, state) {
                    if (cubit.historyLoading) {
                      return const Loading(subColor: subColor);
                    }
                    if (cubit.publicHistory.isEmpty) {
                      return const NoResult(
                        message: "No public history!",
                        color: subColor,
                      );
                    }

                    return ListView.builder(
                      itemCount: cubit.publicHistory.length,
                      padding: const EdgeInsets.all(0),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                        HistoryImage(
                          itemModel: cubit.publicHistory[index],
                          color: subColor,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          sameUser: false
                        )
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

