
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/font_family.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_button.dart';
import '../../shared_widgets/screen_background.dart';
import '../search_users/search_users_ui.dart';
import 'check_is_fake_cubit.dart';
import 'check_is_fake_state.dart';


class CheckIsFake extends StatelessWidget {
  const CheckIsFake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color subColor = MainColors.checkIsFakePage;
    CheckIsFakeCubit cubit = CheckIsFakeCubit.getInstance(context);

    return ScreenBackground(
      addBackIcon: false,
      appBarColor: subColor,
      title: "DEEP TRUTH",
      action: IconButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SearchUsers())
          );
        },
        icon: const Icon(Icons.search, color: Colors.white)
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            height: 300,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.grey
                ]
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),

            child: BlocBuilder<CheckIsFakeCubit, CheckIsFakeState>(
              buildWhen: (ps, cs) => cs.updatePickedFile,
              builder: (context, state) {
                return cubit.pickedFile == null? const SizedBox(): Stack(
                  children: [
                    Center(
                      child: Image.file(
                        cubit.pickedFile!,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),

                    IconButton(
                      onPressed: cubit.deletePickedFile,
                      icon: const Icon(Icons.delete, color: Colors.white)
                    )
                  ],
                );
              }
            ),
          ),

          CustomButton(
            onPressed: cubit.onFileUploaded,
            leading: const Icon(Icons.upload, color: Colors.white),
            text: "UPLOAD IMAGE / VIDEO",
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: subColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)
            ),
          ),

          const SizedBox(height: 30),

          BlocBuilder<CheckIsFakeCubit, CheckIsFakeState>(
            buildWhen: (ps, cs) => cs.updatePickedFile,
            builder: (context, state) {
              if (cubit.pickedFile == null) {
                return const Text(
                  "* Allowed Image Extensions: png, jpg, jpeg\n"
                    "* Allowed Video Extensions: mp4",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: subColor,
                    fontFamily: FontFamily.handWriting
                  ),
                );
              }

              return BlocBuilder<CheckIsFakeCubit, CheckIsFakeState>(
                buildWhen: (ps, cs) => cs.updateWaitLoading,
                builder: (context, state) {
                  return Column(
                    children: [
                      InkWell(
                        onDoubleTap: cubit.waitForResponse? null
                          : () => cubit.uploadFile(context, 1),
                        onLongPress: cubit.waitForResponse? null
                          : () => cubit.uploadFile(context, -1),
                        onTap: cubit.waitForResponse? null
                          : () => cubit.uploadFile(context, 0),
                        child: CustomButton(
                          onPressed: null,
                          text: "CHECK IF FAKE",
                          color: subColor,
                          isLoading: cubit.waitForResponse,
                          leading: const Icon(Icons.check_circle_outline, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
              );
            }
          ),
        ],
      ),
    );
  }
}


