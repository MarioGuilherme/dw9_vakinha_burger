import "dart:convert";

class AuthModel {
  final String accessToken;
  final String refreshToken;

  AuthModel({
    required this.accessToken,
    required this.refreshToken
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "access_token": this.accessToken,
      "refresh_token": this.refreshToken
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      accessToken: map["access_token"] ?? "",
      refreshToken: map["refresh_token"] ?? ""
    );
  }

  String toJson() => json.encode(this.toMap());

  factory AuthModel.fromJson(String source) => AuthModel.fromMap(json.decode(source));
}