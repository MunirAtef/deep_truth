
import 'dart:io';

import 'package:deep_truth/screens/history/history_item/history_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/main_colors.dart';
import '../../resources/pick_image.dart';
import '../../shared_widgets/loading_dialog.dart';
import 'home_page_state.dart';



class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(): super(HomePageState());

  static HomePageCubit getInstance(BuildContext context) =>
    BlocProvider.of<HomePageCubit>(context);

  int routeIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final Color subColor = MainColors.drawer;

  void updateRoute(int index) {
    if (index != routeIndex) {
      if (routeIndex == 1) HistoryImage.dismissAll();
      routeIndex = index;
      emit(HomePageState(updateRoute: true));
    }
  }

  Future<bool> onWillPop() async {
    if (scaffoldKey.currentState?.isDrawerOpen == true) return true;
    if (routeIndex == 0) return true;
    routeIndex = 0;
    emit(HomePageState(updateRoute: true));
    return false;
  }

  void updateMarketplaceLogo(BuildContext context) async {
    // NavigatorState navigator = Navigator.of(context);

    File? pickedImage = await PickImage.pickImage(
      context: context,
      color: subColor,
      onDelete:() {}
    );



    if (pickedImage != null) {
      showLoading(
        context: context,
        title: "UPDATING IMAGE",
        color: subColor,
        waitFor: () async {
          emit(HomePageState(updateMpLogo: true));
        }
      );
    }
  }

  void contactLinkedin() {
    launchUrl(
      Uri.parse("https://www.linkedin.com/in/munir-m-atef-573255215"),
      mode: LaunchMode.externalApplication
    );
  }

  void contactWhatsapp() {
    launchUrl(
      Uri.parse("https://wa.me/+201146721499"),
      mode: LaunchMode.externalApplication
    );
  }

  void contactFacebook() {
    launchUrl(
      Uri.parse("https://www.facebook.com/munir-atef.52"),
      mode: LaunchMode.externalApplication
    );
  }

  void contactGmail() {
    launchUrl(
      Uri.parse("mailto:munir.atef1729@gmail.com?to=&subject=&body=Hi Munir, "),
      mode: LaunchMode.externalApplication
    );
  }
}
