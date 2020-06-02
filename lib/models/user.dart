import 'dart:convert';

class User {
  dynamic id;
  dynamic fullName;
  dynamic userName;
  dynamic email;
  dynamic gender;
  dynamic birthDate;
  dynamic deviceToken;
  dynamic deviceType;
  dynamic userImage;

  User({
    this.id,
    this.fullName,
    this.userName,
    this.email,
    this.gender,
    this.birthDate,
    this.deviceToken,
    this.deviceType,
    this.userImage,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        userName: json["user_name"],
        email: json["email"],
        gender: json["gender"],
        birthDate: json["birth_date"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        userImage: json["user_image"],
      );
}
