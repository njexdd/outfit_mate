import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/database/app_database.dart';
import '../user_prefs.dart';

class GeminiService {
  static const String _baseUrl = 'https://outfitmate-proxy-api.vercel.app';

  static Future<Map<String, dynamic>?> generateOutfit({
    required List<ClothingItem> wardrobe,
    required double temperature,
    required String condition,
    required String activity,
    required bool isLongOutside,
    required bool isOfficial,
  }) async {
    final wardrobeJson = wardrobe
        .map(
          (item) => {
            'id': item.id,
            'name': item.name,
            'category': item.category,
            'subCategory': item.subCategory,
            'color': item.color,
            'warmthLevel': item.warmthLevel,
            'style': item.style,
          },
        )
        .toList();

    final gender = UserPrefs.gender;
    final age = UserPrefs.ageGroup;
    final coldSensitivity = UserPrefs.coldSensitivity;
    final prefStyle = UserPrefs.style;
    final prefColors = UserPrefs.colorPalette;

    final prompt =
        """
Ты — профессиональный ИИ-стилист. Твоя задача — собрать идеальный образ из предложенного гардероба.

СИТУАЦИЯ:
- Погода: $temperature°C, $condition
- Мероприятие: $activity
- Долго на улице: ${isLongOutside ? 'Да' : 'Нет'}
- Дресс-код: ${isOfficial ? 'Строгий/Официальный' : 'Свободный'}

КЛИЕНТ:
- Пол: $gender, Возраст: $age
- Переносимость холода: $coldSensitivity (1-мерзнет, 2-нормально, 3-всегда жарко)
- Любимый стиль: $prefStyle
- Цветовая палитра: $prefColors

ГАРДЕРОБ (Формат JSON):
${jsonEncode(wardrobeJson)}

ИНСТРУКЦИЯ:
1. Выбери вещи из гардероба, чтобы получился законченный, стильный и уместный образ по погоде.
2. Используй ТОЛЬКО ID вещей, которые есть в предоставленном JSON. Не придумывай новые ID.
3. Соблюдай температурный режим. Если холодно, обязательно добавь верхнюю одежду (outerwear_id).
4. Если подходящей вещи для категории нет, передай null.
5. Напиши короткое, дружелюбное описание (description), почему ты выбрал именно этот образ (2-3 предложения), обращаясь к клиенту на "Вы".

ВАЖНО: Ответь СТРОГО в формате JSON без markdown-разметки (без ```json), по следующему шаблону:
{
  "top_id": 1,
  "bottom_id": 2,
  "shoes_id": 3,
  "outerwear_id": null,
  "accessory_id": null,
  "description": "Текст..."
}
""";

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultText = data['result'] as String;

        final cleanJson = resultText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        return jsonDecode(cleanJson) as Map<String, dynamic>;
      } else {
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
      print('Ошибка Gemini API: $e');
      rethrow;
    }
  }
}
