class SignInRequest {
  String username;
  String password;

  SignInRequest({required this.username, required this.password});

  factory SignInRequest.fromJson(Map<String, dynamic> json){
    return SignInRequest(
      username: json['username'],
      password: json['password'],
    );
  }
}
