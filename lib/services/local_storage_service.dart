import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _tokenKey = 'auth_token';
  static const _cpfKey = 'user_cpf';

  Future<void> saveLoginData(String token, String cpf) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_cpfKey, cpf);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getCpf() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_cpfKey);
  }

  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_cpfKey);
  }
}
