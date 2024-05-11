
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../general/connectivity_check.dart';
import '../../resources/main_colors.dart';
import '../check_is_fake/check_is_fake_ui.dart';
import '../connections/connections_ui.dart';
import '../history/history_ui.dart';
import '../settings/settings_ui.dart';
import 'custom_drawer_ui.dart';
import 'home_page_cubit.dart';
import 'home_page_state.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageCubit cubit = HomePageCubit.getInstance(context);
    ConnectivityCheck.connectivityListener(context);

    const List<Widget> routes = [
      CheckIsFake(),
      Connections(),
      History(),
      Settings(),
    ];

    final List<Color> colors = [
      MainColors.checkIsFakePage,
      MainColors.connectionsPage,
      MainColors.historyPage,
      MainColors.settingsPage,
    ];

    return WillPopScope(
      onWillPop: cubit.onWillPop,
      child: BlocBuilder<HomePageCubit, HomePageState>(
        buildWhen: (ps, cs) => cs.updateRoute,
        builder: (context, state) {
          int routeIndex = cubit.routeIndex;

          return Scaffold(
            key: cubit.scaffoldKey,
            body: routes[routeIndex],

            bottomNavigationBar: SnakeNavigationBar.gradient(
              height: 60,
              backgroundGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MainColors.appColorDark,
                  colors[routeIndex]
                ]
              ),

              selectedItemGradient: const LinearGradient(
                colors: [Colors.white, Colors.white]
              ),

              unselectedItemGradient: const LinearGradient(
                colors: [Colors.grey, Colors.grey]
              ),

              snakeViewGradient: LinearGradient(
                colors: [Colors.black, colors[cubit.routeIndex], Colors.black]
              ),

              snakeShape: SnakeShape.rectangle,

              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12
              ),

              showUnselectedLabels: true,
              showSelectedLabels: true,

              currentIndex: routeIndex,
              onTap: (index) => cubit.updateRoute(index),

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.group_add),
                  label: 'Connections'
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'History'
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings'
                ),
              ],
            ),

            drawer: const CustomDrawer(),
          );
        }
      ),
    );
  }
}

