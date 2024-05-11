
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/assets.dart';
import '../../resources/font_family.dart';
import '../../resources/main_colors.dart';
import 'home_page_cubit.dart';
import 'home_page_state.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageCubit cubit = HomePageCubit.getInstance(context);
    const Color subColor =  MainColors.drawer;

    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              MainColors.appColorDark,
              subColor
            ]
          )
        ),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            /// Marketplace logo
            Center(
              child: Stack(
                children: [
                  BlocBuilder<HomePageCubit, HomePageState>(
                    buildWhen: (ps, cs) => cs.updateMpLogo,
                    builder: (context, state) {
                      return ClipOval(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AssetImages.googleIcon,
                              width: 100,
                            ),
                          ),
                        )
                      );
                    }
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () => cubit.updateMarketplaceLogo(context),
                        icon: const Icon(Icons.add_a_photo, color: subColor, size: 20)
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// Marketplace name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<HomePageCubit, HomePageState>(
                  buildWhen: (ps, cs) => cs.updateMpName,
                  builder: (context, state) {
                    return const Text(
                      "Munir M. Atef",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white
                      ),
                    );
                  }
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.white)
                )
              ]
            ),

            const Divider(thickness: 2, height: 2, color: Colors.grey),


            /// Logout
            TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.white),

                  SizedBox(width: 20),

                  Text(
                    "LOGOUT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              )
            ),

            const Spacer(),

            /// About developer section
            const Divider(thickness: 2, color: Colors.grey),

            const Text(
              "ABOUT DEVELOPER",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: FontFamily.handWriting
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    AssetImages.hourglass,
                    width: 100,
                    height: 100
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Munir M. Atef",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white
                      ),
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      width: 130,
                      child: Text(
                        "Faculty of Computers & Artificial Intelligence",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    SizedBox(
                      width: 130,
                      child: Text(
                        "Flutter & Native Android Developer",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text(
              "CONTACT ME",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: cubit.contactLinkedin,
                  icon: const ImageIcon(
                    AssetImage(AssetImages.linkedinIcon),
                    color: Colors.white, size: 30
                  )
                ),
                IconButton(
                  onPressed: cubit.contactWhatsapp,
                  icon: const Icon(Icons.whatsapp, color: Colors.white, size: 35)
                ),
                IconButton(
                  onPressed: cubit.contactFacebook,
                  icon: const Icon(Icons.facebook, color: Colors.white, size: 35)
                ),
                IconButton(
                  onPressed: cubit.contactGmail,
                  icon: const Icon(Icons.email_outlined, color: Colors.white, size: 35)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

