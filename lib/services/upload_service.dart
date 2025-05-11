import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';
import 'dart:convert'; // Para JSON

class UploadService {
  final String apiUrl =
      'https://fastapi.ajvale.com.br/buscar-similaridade-foto/';

  Future<Map<String, dynamic>> enviarImagem(
    File imageFile,
    String token,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
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
}