
import 'package:deep_truth/resources/font_family.dart';
import 'package:flutter/material.dart';

import '../resources/assets.dart';

class NoResult extends StatelessWidget {
  final String message;
  final Color color;
  const NoResult({
    Key? key,
    required this.message,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Expanded(
          child: Image.asset(AssetImages.noResult, width: double.infinity)
        ),

        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontFamily: FontFamily.handWriting,
            color: color
          ),
        ),

        const SizedBox(height: 50),
      ],
    );
  }
}
