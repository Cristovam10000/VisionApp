import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  Future<void> enviarImagem(File imageFile, String token) async {
    final uri = Uri.parse('https://fastapi.ajvale.com.br/buscar-similaridade-foto/');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Imagem enviada com sucesso");
    } else {
      print("❌ Erro ao enviar imagem: ${response.statusCode}");
    }
  }
}
