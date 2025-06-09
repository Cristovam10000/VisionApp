import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenService {
  // Implementação de singleton
  static final AuthTokenService _instance = AuthTokenService._internal();
  factory AuthTokenService() => _instance;
  AuthTokenService._internal();

  // Chave para armazenar o token nas SharedPreferences
  static const String _tokenKey = 'auth_token';
  
  // Cache do token
  String? _cachedToken;

  // Obter o token atual (da memória ou do armazenamento)
  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(_tokenKey);
    return _cachedToken;
  }

  // Getter síncrono (pode retornar null se não carregado ainda)
  String? get token => _cachedToken;

  // Salvar um novo token
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

}