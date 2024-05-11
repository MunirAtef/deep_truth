
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/check_is_fake/check_is_fake_cubit.dart';
import 'screens/choose_login_type/choose_login_type_cubit.dart';
import 'screens/connections/connections_cubit.dart';
import 'screens/history/history_cubit.dart';
import 'screens/home_page/home_page_cubit.dart';
import 'screens/register/register_cubit.dart';
import 'screens/search_users/search_users_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'screens/splash/splash_cubit.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/user_profile/user_profile_cubit.dart';


void main() {
  runApp(const DeepTruth());
}


class DeepTruth extends StatelessWidget {
  const DeepTruth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SplashCubit()),
        BlocProvider(create: (BuildContext context) => RegisterCubit()),
        BlocProvider(create: (BuildContext context) => HomePageCubit()),
        BlocProvider(create: (BuildContext context) => ChooseLoginTypeCubit()),
        BlocProvider(create: (BuildContext context) => HistoryCubit()),
        BlocProvider(create: (BuildContext context) => CheckIsFakeCubit()),
        BlocProvider(create: (BuildContext context) => SettingsCubit()),
        BlocProvider(create: (BuildContext context) => SearchUsersCubit()),
        BlocProvider(create: (BuildContext context) => UserProfileCubit()),
        BlocProvider(create: (BuildContext context) => ConnectionsCubit()),
      ],
      child: MaterialApp(
        home: const SplashScreen(),
        title: "Deep Truth",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
