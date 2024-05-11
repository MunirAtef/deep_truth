
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:deep_truth/models/history_item_model.dart';
import 'package:flutter/material.dart';

import '../backend_logic/auth_request.dart';
import '../resources/assets.dart';
import '../resources/request_urls.dart';
import 'custom_container.dart';
import 'failed_to_load.dart';


class ResultDialog extends StatelessWidget {
  final HistoryItemModel itemModel;
  final File? imageFile;

  const ResultDialog({
    Key? key,
    required this.itemModel,
    this.imageFile
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(vertical: 0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),

      content: CustomContainer(
        width: width - 80,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "MODEL RESULT",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19
              ),
            ),

            const SizedBox(height: 10),

            if (itemModel.faces.isEmpty) const Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: Text(
                "No faces detected",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red
                ),
              ),
            ),

            if (itemModel.faces.isNotEmpty) _DrawImageResult(
              itemModel: itemModel,
              imageFile: imageFile,
              width: width - 120,
              height: width - 120,
            )
          ],
        ),
      ),
    );
  }
}



class _DrawImageResult extends StatelessWidget {
  final HistoryItemModel itemModel;
  final File? imageFile;
  final double width;
  final double height;

  const _DrawImageResult({
    Key? key,
    required this.itemModel,
    this.imageFile,
    required this.width,
    required this.height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          if (imageFile != null) Image.file(
            imageFile!,
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),

          if (imageFile == null) CachedNetworkImage(
            imageUrl: "${RequestUrls.getFile}?filename=${itemModel.filename}",
            width: width,
            height: height,
            fit: BoxFit.fill,
            httpHeaders: {
              "Authorization": 'Bearer ${AuthRequest.inst.currentUser?.accessToken}'
            },
            placeholder: (_, __) => Image.asset(AssetImages.hourglass),
            errorWidget: (_, __, ___) => const FailedToLoad(),
          ),

          ...itemModel.faces.map((face) {
            return Positioned(
              left: face.posX * width,
              top: face.posY * height,
              child: Container(
                width: face.width * width,
                height: face.height * height,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  border: Border.all(
                    color: face.type == "fake"? Colors.red: Colors.green,
                    width: 3
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: face.width * width,
                      color: Colors.white,
                      child: Text(
                        face.type,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: face.type == "fake"? Colors.red: Colors.green,
                          backgroundColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 8
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

