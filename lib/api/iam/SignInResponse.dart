class SignInResponse {
  int id;
  String username;
  String token;

  SignInResponse({required this.id, required this.username, required this.token});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'],
      username: json['username'],
      token: json['token'],
    );
  }
}