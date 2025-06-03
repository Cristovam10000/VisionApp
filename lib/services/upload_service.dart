import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';
import 'dart:convert'; // Para JSON


class UploadService {
  final String baseUrl = 'https://fastapi.ajvale.com.br';
  final String uploadEndpoint = '/buscar-similaridade-foto/';
  final String fichaEndpoint = '/buscar-ficha-criminal';

  Future<Map<String, dynamic>> enviarImagem(
  String matricula,
  File imageFile,
  String token,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl$uploadEndpoint?matricula=$matricula');

      final request = http.MultipartRequest('POST', uri);

      // Cabeçalhos
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Arquivo da imagem
      final mimeTypeStr = mime.lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      final contentType = MediaType.parse(mimeTypeStr);
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: contentType,
      );

      request.files.add(multipartFile);

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception('Falha ao enviar imagem: ${response.statusCode}');
      }

      if (kDebugMode) {
        print('Imagem enviada com sucesso!');
        print('Resposta: $responseData');
      }

      return json.decode(responseData);
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar imagem: $e');
      }
      rethrow;
    }
  }


  Future<Map<String, dynamic>> buscarFichaPorCpf(String cpf, String matricula, String token) async {
  // Adiciona a matrícula como parâmetro de consulta (query parameter)
  final Uri url = Uri.parse(
    'https://fastapi.ajvale.com.br/buscar-ficha-criminal/$cpf?matricula=$matricula',
  );

  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'accept': 'application/json',
      },
    );

    if (kDebugMode) {
      print('🔐 Token: $token');
      print('📞 URL: $url');
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar ficha: ${response.statusCode}');
    }

    return json.decode(response.body);
  } catch (e) {
    if (kDebugMode) {
      print('Erro: $e');
    }
    rethrow;
  }
}

}