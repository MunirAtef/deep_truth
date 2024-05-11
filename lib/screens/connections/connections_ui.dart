
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/main_colors.dart';
import '../../shared_widgets/screen_background.dart';
import 'connected.dart';
import 'connections_cubit.dart';

class Connections extends StatelessWidget {
  const Connections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const subColor = MainColors.connectionsPage;
    ConnectionsCubit cubit = ConnectionsCubit.getInstance(context);
    cubit.getConnections();

    return ScreenBackground(
      appBarColor: subColor,
      addBackIcon: false,
      title: "CONNECTIONS",
      body: DefaultTabController(
        length: 3,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)
          ),
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: const Color.fromRGBO(100, 100, 100, 0.1),
              elevation: 0,
              bottom: const TabBar(
                indicatorWeight: 4,
                indicatorColor: MainColors.connectionsPage,
                labelColor: MainColors.connectionsPage,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
                physics: BouncingScrollPhysics(),
                tabs: [
                  Tab(text: 'CONNECTIONS'),
                  Tab(text: 'OUTGOING'),
                  Tab(text: 'INCOMING'),
                ],
              ),
            ),

            body: TabBarView(
              children: [
                Connected(),
                Center(child: Text('Content for Tab 2')),
                Center(child: Text('Content for Tab 3')),
              ],
            ),
          ),
        )
      )
    );
  }
}

