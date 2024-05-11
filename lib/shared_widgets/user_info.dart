
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../resources/main_colors.dart';
import '../resources/request_urls.dart';
import 'user_image.dart';

class UserInfo extends StatelessWidget {
  final UserModel userModel;
  final Color color;
  final bool clipBottom;

  const UserInfo({
    Key? key,
    required this.userModel,
    required this.color,
    this.clipBottom = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = userModel.profilePicture == null? null
      : "${RequestUrls.profilePicture}?filename=${userModel.profilePicture}";

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: Radius.circular(clipBottom? 10: 0),
          bottomRight: Radius.circular(clipBottom? 10: 0)
        ),
        child: Row(
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: UserSquareImage(
                imageUrl: imageUrl,
                width: 84,
                borderRadius: BorderRadius.zero,
              ),
            ),

            const SizedBox(width: 4),

            Expanded(
              child: Column(
                children: [
                  InfoBox(
                    text: userModel.email,
                    iconData: Icons.email,
                    color: color,
                  ),

                  const SizedBox(height: 4),

                  InfoBox(
                    text: userModel.name,
                    iconData: Icons.person,
                    color: color,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class InfoBox extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color color;


  const InfoBox({
    Key? key,
    required this.text,
    required this.iconData,
    required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MainColors.appColorDark,
            color
          ]
        ),
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              decoration: TextDecoration.underline
            ),
          ),
        ],
      ),
    );
  }
}
