class AuthModel {
  String accessToken;
  String refreshToken;
  String tokenType;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}
