
import '../resources/fixed_names.dart';
import 'face_model.dart';


class HistoryItemModel {
  String filename;
  List<FaceModel> faces;
  int date;
  String type = "_";

  HistoryItemModel({
    required this.filename,
    required this.faces,
    required this.date
  }) {
    String ext = filename.split('.').last;

    if (['png', 'jpg', 'jpeg'].contains(ext)) {
      type = MediaType.image;
    } else if (ext == 'mp4') {
      type = MediaType.video;
    }
  }

  factory HistoryItemModel.fromJson(dynamic json) {
    json as Map;
    return HistoryItemModel(
      filename: json["filename"],
      faces: FaceModel.fromJsonList(json["result"]),
      date: json["date"]
    );
  }

  static List<HistoryItemModel> fromJsonList(jsonList) {
    jsonList as List;
    return jsonList.map((e) => HistoryItemModel.fromJson(e)).toList();
  }
}

