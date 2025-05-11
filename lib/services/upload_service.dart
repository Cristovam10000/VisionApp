import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';
import 'dart:convert'; // Para JSON

class UploadService {
  final String baseUrl = 'https://fastapi.ajvale.com.br';
  final String uploadEndpoint = '/buscar-similaridade-foto/';
  final String fichaEndpoint = '/buscar-ficha-criminal';

  Future<Map<String, dynamic>> enviarImagem(
    File imageFile,
    String token,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$uploadEndpoint'));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      var stream = imageFile.openRead();
      var length = await imageFile.length();
      final mimeTypeStr =
          mime.lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      var contentType = MediaType.parse(mimeTypeStr);

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: contentType,
      );

      request.files.add(multipartFile);

      final response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception('Falha ao enviar imagem: ${response.statusCode}');
      }

      print('Imagem enviada com sucesso!');
      print('Body: $responseData');

      return json.decode(responseData);
    } catch (e) {
      print('Erro ao enviar imagem: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buscarFichaPorCpf(String cpf, String token) async {
    // Usando GET com o CPF na URL conforme indicado pelo backend
    final Uri url = Uri.parse('https://fastapi.ajvale.com.br/buscar-ficha-criminal/$cpf');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      );

      print('🔐 Token: $token');
      print('📞 URL: $url');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
      
      if (response.statusCode != 200) {
        throw Exception('Erro ao buscar ficha: ${response.statusCode}');
      }

      return json.decode(response.body);
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }
}