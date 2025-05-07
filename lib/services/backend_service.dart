import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> autenticarComBackend(String firebaseToken) async {
  const backendUrl = 'https://fastapi.ajvale.com.br/auth/firebase'; 

  final response = await http.post(
    Uri.parse(backendUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': firebaseToken}),
  );

  if (response.statusCode == 200) {
    final dados = jsonDecode(response.body);
    return dados['access_token']; // chave usada no backend para o JWT eu acho
  } else {
    print('Erro backend: ${response.statusCode} - ${response.body}');
    return null;
  }
}
