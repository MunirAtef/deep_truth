
import 'package:flutter/material.dart';

import '../resources/assets.dart';
import '../resources/font_family.dart';

class FailedToLoad extends StatelessWidget {
  const FailedToLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        ImageIcon(
          AssetImage(AssetImages.noImage),
          color: Colors.red,
          size: 120,
        ),

        Text(
          "Failed To Load",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            fontFamily: FontFamily.handWriting,
            color: Colors.red,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 4
              )
            ]
          ),
        ),
      ],
    );
  }
}

