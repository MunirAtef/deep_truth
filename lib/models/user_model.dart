

class UserModel {
  String id;
  String name;
  String email;
  String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture
  });

  factory UserModel.fromJson(json) => UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      profilePicture: json["profile_picture"]
  );


  static List<UserModel> fromJsonList(json) =>
    (json as List).map((e) => UserModel.fromJson(e)).toList();
}


class AppUserModel extends UserModel {
  String accessToken;
  String refreshToken;

  AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required this.accessToken,
    required this.refreshToken,
    super.profilePicture
  });

  Map<String, String> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    if (profilePicture != null) "profile_picture": profilePicture!
  };

  factory AppUserModel.fromJson(Map json) => AppUserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    accessToken: json["access_token"] ?? "_",
    refreshToken: json["refresh_token"] ?? "_",
    profilePicture: json["profile_picture"]
  );
}

