
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/assets.dart';
import '../../resources/font_family.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/custom_container.dart';
import 'splash_cubit.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashCubit? cubit;

  @override
  Widget build(BuildContext context) {
    cubit ??= BlocProvider.of<SplashCubit>(context)..init(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MainColors.appColorDark,
              MainColors.splashSecondColor,
              MainColors.homePage
            ]
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),

            CustomContainer(
              width: 200,
              height: 150,
              shadowColor: Colors.grey[600]!,
              child: Image.asset(AssetImages.appIcon, width: 200, height: 150, fit: BoxFit.contain),
            ),

            const SizedBox(height: 20),

            BlocBuilder<SplashCubit, int>(
              builder: (context, state) {
                return Text(
                  cubit!.appName.substring(0, state),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    color: Colors.yellowAccent,
                    fontFamily: FontFamily.handWriting
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

