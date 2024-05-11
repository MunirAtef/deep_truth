
import 'package:flutter/material.dart';

import '../resources/assets.dart';
import '../resources/font_family.dart';
import '../resources/main_colors.dart';


class Loading extends StatelessWidget {
  final Color? subColor;

  const Loading({Key? key, this.subColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(AssetImages.waiting),
          ),

          Text(
            "Loading.. please wait",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: subColor ?? MainColors.appColorDark,
              fontFamily: FontFamily.handWriting
            ),
          ),

          const SizedBox(height: 30)
        ],
      ),
    );
  }
}


