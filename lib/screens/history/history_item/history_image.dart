
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deep_truth/resources/request_urls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../backend_logic/auth_request.dart';
import '../../../models/history_item_model.dart';
import '../../../resources/assets.dart';
import '../../../resources/fixed_names.dart';
import '../../../resources/main_colors.dart';
import '../../../resources/shared_functions.dart';
import '../../../shared_widgets/failed_to_load.dart';
import 'bottom_sheets.dart';


class HistoryImage extends StatelessWidget {
  final HistoryItemModel itemModel;
  final Color color;
  final EdgeInsets margin;
  final bool sameUser;

  const HistoryImage({
    Key? key,
    required this.itemModel,
    this.color = MainColors.historyPage,
    this.margin = const EdgeInsets.all(5),
    this.sameUser = true
  }) : super(key: key);

  static final Map<String, VideoPlayerController> _controllers = {};

  static void dismissAll() {
    for (String player in _controllers.keys) {
      _controllers[player]!.pause();
      _controllers[player]!.dispose();
    }
    _controllers.clear();
  }

  FutureBuilder videoPlayer() {
    VideoPlayerController? controller = _controllers[itemModel.filename];
    if (controller == null) {
      controller = VideoPlayerController.networkUrl(
          Uri.parse(itemModel.filename));
      _controllers[itemModel.filename] = controller;
    }

    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (controller!.value.isInitialized) {
          controller.setLooping(true);
          controller.play();

          return Stack(
            children: [
              VideoPlayer(controller),

              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 0.7),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: StatefulBuilder(
                    builder: (context, setInternalState) {
                      bool isPlaying = controller!.value.isPlaying;

                      return IconButton(
                        onPressed: () {
                          isPlaying ? controller!.pause() : controller!.play();
                          setInternalState(() {});
                        },
                        icon: Icon(
                          isPlaying? Icons.pause: Icons.play_arrow,
                          color: Colors.white
                        )
                      );
                    }
                  ),
                ),
              )
            ],
          );
        } else {
          return Image.asset(AssetImages.hourglass);
        }
      }
    );
  }

  CachedNetworkImage imageGetter() {
    return CachedNetworkImage(
      imageUrl: "${RequestUrls.getFile}?filename=${itemModel.filename}",
      httpHeaders: {
        "Authorization": 'Bearer ${AuthRequest.inst.currentUser?.accessToken}'
      },
      placeholder: (_, __) => Image.asset(AssetImages.hourglass),
      errorWidget: (_, __, ___) => const FailedToLoad(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: 250,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey
          ]
        ),
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),

      child: Column(
        children: [
          Expanded(
            child: InkWell(
              child: itemModel.type == MediaType.video? videoPlayer()
                : imageGetter(),

              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => HistoryItemOptions(
                    itemModel: itemModel,
                    sameUser: sameUser,
                    color: color,
                  )
                );
              },
            ),
          ),

          Container(
            width: double.infinity,
            height: 40,
            padding: const EdgeInsets.only(left: 10, right: 20),
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
                const Spacer(),

                Text(
                  Shared.getDate(itemModel.date * 1000),
                  style: const TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 13
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

