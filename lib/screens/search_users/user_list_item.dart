
import 'package:deep_truth/resources/request_urls.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../resources/main_colors.dart';
import '../../shared_widgets/user_image.dart';
import '../../shared_widgets/custom_container.dart';
import '../user_profile/user_profile_ui.dart';

class UserListItem extends StatelessWidget {
  final UserModel model;
  const UserListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl = model.profilePicture == null? null
      : "${RequestUrls.profilePicture}?filename=${model.profilePicture}";

    return CustomContainer(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      padding: const EdgeInsets.all(10),
      shadowColor: Colors.grey.shade300,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => UserProfile(model: model))
          );
        },
        child: Row(
          children: [
            UserSquareImage(
              imageUrl: imageUrl,
              width: 45,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5)
              ),
            ),

            const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  model.email,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    // color: Color.fromRGBO(120, 120, 120, 1),
                    color: MainColors.searchUsersPage
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

