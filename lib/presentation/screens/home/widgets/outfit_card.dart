import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/database/app_database.dart';
import '../../wardrobe/item_detail_screen.dart';

class OutfitCard extends StatelessWidget {
  final Map<String, ClothingItem?>? outfit;
  final String? description;

  const OutfitCard({super.key, this.outfit, this.description});

  @override
  Widget build(BuildContext context) {
    // 1. Состояние: Образ еще не сгенерирован
    if (outfit == null) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.grey.shade200,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.checkroom_rounded,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                "Нажмите кнопку выше,\nчтобы ИИ собрал вам образ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Состояние: Образ готов
    // Извлекаем только те вещи, которые не null
    final items = outfit!.values.whereType<ClothingItem>().toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Блок с описанием от стилиста
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              // Делаем фон чуть чище, убираем серый/цветной залив целиком
              color: Colors.white, 
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100, width: 1.5),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Декоративная огромная кавычка на фоне для создания "журнального" стиля
                Positioned(
                  right: -10,
                  top: -15,
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 80,
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.04),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок с акцентной иконкой-бейджем
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.auto_awesome, 
                            color: Theme.of(context).primaryColor, 
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Совет стилиста",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      // Сам текст оформлен как цитата (левая цветная линия)
                      Container(
                        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          description!,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6, // Увеличенный межстрочный интервал для читабельности
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Сетка с вещами
          Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 12, // Отступ по горизонтали
              runSpacing: 12, // Отступ по вертикали
              children: items.map((item) => _buildItemTile(context, item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Виджет отдельной карточки вещи
  Widget _buildItemTile(BuildContext context, ClothingItem item) {
    // Вычисляем ширину для 2-х колонок с учетом padding (20 с каждой стороны) и spacing (12)
    final double cardWidth = (MediaQuery.of(context).size.width - 40 - 40 - 12) / 2;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(itemId: item.id),
        ),
      ),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фотография вещи
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1, // Квадратные изображения смотрятся аккуратнее
                child: Image.file(
                  File(item.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Текстовая информация
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}