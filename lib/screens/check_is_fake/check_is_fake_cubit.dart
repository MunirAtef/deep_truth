
import 'dart:io';

import 'package:deep_truth/models/history_item_model.dart';
import 'package:deep_truth/shared_widgets/draw_image_result.dart';
import 'package:deep_truth/shared_widgets/failed_to_load.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../backend_logic/file_request.dart';
import '../../models/face_model.dart';
import 'check_is_fake_state.dart';

class CheckIsFakeCubit extends Cubit<CheckIsFakeState> {
  CheckIsFakeCubit(): super(CheckIsFakeState());

  static CheckIsFakeCubit getInstance(BuildContext context) =>
    BlocProvider.of<CheckIsFakeCubit>(context);

  File? pickedFile;
  bool waitForResponse = false;
  // int sentPercentage = 0;


  void onFileUploaded() async {
    String? filePath = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["png", "jpg", "jpeg", "mb4"]))?.files[0].path;

    if (filePath == null) return;
    pickedFile = File(filePath);
    emit(CheckIsFakeState(updatePickedFile: true));
  }

  void deletePickedFile() {
    pickedFile = null;
    emit(CheckIsFakeState(updatePickedFile: true));
  }


  Future<void> uploadFile(BuildContext context, int th) async {
    if (pickedFile == null) return;
    waitForResponse = true;
    emit(CheckIsFakeState(updateWaitLoading: true));
    List<FaceModel>? faces = await FileRequest.inst.uploadFile(
      file: pickedFile!,
      th: th
    );

    waitForResponse = false;
    emit(CheckIsFakeState(updateWaitLoading: true));

    showDialog(
      context: context,
      builder: (context) {
        if (faces != null && pickedFile != null) {
          return ResultDialog(
            imageFile: pickedFile,
            itemModel: HistoryItemModel(
              filename: "_",
              faces: faces,
              date: DateTime.now().millisecondsSinceEpoch
            ),
          );
        }

        return const FailedToLoad();
      }
    );
  }
}
