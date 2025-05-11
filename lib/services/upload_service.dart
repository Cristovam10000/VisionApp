import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';


class UploadService {
  final String apiUrl = 'https://fastapi.ajvale.com.br/buscar-similaridade-foto/';

  Future<void> enviarImagem(File imageFile, String token) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      var stream = imageFile.openRead();
      var length = await imageFile.length();

      // Detectar o tipo MIME
      final mimeTypeStr = mime.lookupMimeType(imageFile.path) ?? 'application/octet-stream';

      // Criar um MediaType
      var contentType = MediaType.parse(mimeTypeStr);

      // Criar MultipartFile
      var multipartFile = http.MultipartFile(
        'file', // Nome do campo no servidor
        stream,
        length,
        filename: imageFile.path.split('/').last, // Usar o nome original do arquivo
        contentType: contentType, // Usar o MediaType
      );

      request.files.add(multipartFile);

      final response = await request.send();
      var responseData = await response.stream.toBytes();
      String responseString = String.fromCharCodes(responseData);

      print('Response: $responseString');

      if (response.statusCode != 200) {
        throw Exception('Falha ao enviar imagem: ${response.statusCode}');
      }

      print('Imagem enviada com sucesso!');

      // Ler o conteúdo do corpo da resposta
      final responseBody = await response.stream.bytesToString();

      print('Body: $responseBody');
    } catch (e) {
      print('Erro ao enviar imagem: $e');
    }
  }
}
