class LoginRequest {
  LoginRequest({
    this.username,
    this.phoneNumber,
    this.password,
  });

  LoginRequest.fromJson(dynamic json) {
    username = json['username'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
  }

  String? username;
  String? phoneNumber;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['phoneNumber'] = phoneNumber;
    map['password'] = password;
    return map;
  }
}