import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vision_app/core/constants/api_constants.dart';


/// Envia o Firebase ID token e retorna o JWT do back-end
Future<String?> postWithToken(String firebaseToken) async {

  final uri = Uri.parse('${ApiConstants.token}$firebaseToken');

  try {
    final response = await http.post(
      uri,
      headers: {'accept': 'application/json'},
      body: '',
    );

    if (response.statusCode != 200) {
      if (kDebugMode) {
        print('Erro na requisição POST: ${response.statusCode} – ${response.body}');
      }
      return null;
    }

    // Decodifica o JSON de resposta
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (kDebugMode) {
      print('POST /auth/firebase retornou: $data');
    }

    // Extrai apenas o JWT (campo exato depende da sua API)
    final accessToken = data['access_token'] as String?;
    if (kDebugMode) {
      print('accessToken="$accessToken"');
    }
    return accessToken;

    
  } catch (e) {
    if (kDebugMode) {
      print('Erro ao fazer requisição POST: $e');
    }
    return null;
  }
}


Future<Map<String, dynamic>?> getUserProfile(String backendJwt) async {
  // monta a URI sem query param
  final uri = Uri.parse(ApiConstants.getuser);

  try {
    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $backendJwt',
      },
    );
    

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Perfil obtido!: ${response.body}');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (kDebugMode) {
        print('Erro na requisição GET /usuario/perfil: '
            '${response.statusCode} → ${response.body}');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception no getUserProfile: $e');
    }
    return null;
  }
}
