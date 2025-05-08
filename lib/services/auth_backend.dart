import 'dart:convert';
import 'package:http/http.dart' as http;

/// Envia o Firebase ID token e retorna o JWT do back-end
Future<String?> postWithToken(String firebaseToken) async {
  const baseUrl = 'https://fastapi.ajvale.com.br/auth/firebase?token_data=';
  final uri = Uri.parse('$baseUrl$firebaseToken');

  try {
    final response = await http.post(
      uri,
      headers: {'accept': 'application/json'},
      body: '',
    );

    if (response.statusCode != 200) {
      print('Erro na requisição POST: ${response.statusCode} – ${response.body}');
      return null;
    }

    // Decodifica o JSON de resposta
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print('🔥 POST /auth/firebase retornou: $data');

    // Extrai apenas o JWT (campo exato depende da sua API)
    final accessToken = data['access_token'] as String?;
    print('🔑 accessToken="$accessToken"');
    return accessToken;
  } catch (e) {
    print('Erro ao fazer requisição POST: $e');
    return null;
  }
}


/// Puxa perfil usando o JWT que seu FastAPI gerou,
/// e não mais o Firebase ID token.
///
/// Exemplo de chamada:
///   final perfil = await getUserProfile(backendJwt);
Future<Map<String, dynamic>?> getUserProfile(String backendJwt) async {
  // monta a URI sem query param
  final uri = Uri.parse('https://fastapi.ajvale.com.br/usuario/perfil');

  try {
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $backendJwt',
      },
    );
    

    if (response.statusCode == 200) {
      print('Perfil obtido!: ${response.body}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Erro na requisição GET /usuario/perfil: '
            '${response.statusCode} → ${response.body}');
      return null;
    }
  } catch (e) {
    print('Exception no getUserProfile: $e');
    return null;
  }
}
