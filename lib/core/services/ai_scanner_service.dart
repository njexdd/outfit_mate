import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AiScannerService {
  // Укажите URL вашего развернутого прокси (как в gemini_service.dart)
  static const String _baseUrl = 'https://outfitmate-proxy-api.vercel.app';

  static Future<Map<String, dynamic>?> analyzeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$_baseUrl/api/analyze-item'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imageBase64': base64Image,
          'mimeType': 'image/jpeg',
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Извлекаем сообщение об ошибке из ответа
        String errorMsg = 'Ошибка сервера: ${response.statusCode}';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('error')) {
            errorMsg = errorBody['error'];
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('Ошибка при отправке запроса: $e');
      rethrow; // пробрасываем, чтобы перехватить в UI
    }
  }
}
