class AuthTokenService {
  static final AuthTokenService _instance = AuthTokenService._internal();

  factory AuthTokenService() => _instance;

  AuthTokenService._internal();

  String? _jwt;

  void setToken(String token) {
    _jwt = token;
  }

  String? get token => _jwt;
}