import 'package:foto_zweig/enums/auth_mode_enum.dart';

class FotoUser {
  String uid;
  String name;
  String email;
  AuthModeEnum authMode = AuthModeEnum.READ_ONLY;

  FotoUser({this.uid, this.name, this.email, this.authMode});

  FotoUser.fromJson(json) {
    uid = json["uid"];
    name = json["name"];
    email = json["email"];
    if (json["mode"] == 1)
      authMode = AuthModeEnum.ADMIN;
  }
}