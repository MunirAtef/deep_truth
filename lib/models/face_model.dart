
class FaceModel {
  double posX;
  double posY;
  double width;
  double height;
  String type;

  FaceModel({
    required this.posX,
    required this.posY,
    required this.width,
    required this.height,
    required this.type
  });

  factory FaceModel.fromJson(json) {
    json as Map;
    List pos = json["position"] as List;

    return FaceModel(
      posX: pos[0].toDouble(),
      posY: pos[1].toDouble(),
      width: pos[2].toDouble(),
      height: pos[3].toDouble(),
      type: json["type"]
    );
  }

  static List<FaceModel> fromJsonList(jsonList) {
    jsonList as List;
    return jsonList.map((e) => FaceModel.fromJson(e)).toList();
  }

  @override
  String toString() {
    // TODO: implement toString
    return "'$type: [($posX, $posY), ($width, $height)]'";
  }
}
