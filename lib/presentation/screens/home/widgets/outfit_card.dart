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
    // 1. Состояние: образ ещё не сгенерирован
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

    // 2. Состояние: образ готов
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
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100, width: 1.5),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
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
                            height: 1.6,
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

          // Сетка вещей — идентична гардеробу
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 12) / 2;
                final cardHeight = cardWidth / 0.73;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((item) => SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: _buildItemTile(context, item),
                  )).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, ClothingItem item) {
    final colorValue = item.color.length == 8
        ? Color(int.parse(item.color, radix: 16))
        : Colors.grey.shade300;

    final warmthIcon = item.warmthLevel == 3
        ? Icons.ac_unit_rounded
        : (item.warmthLevel == 1
            ? Icons.wb_sunny_rounded
            : Icons.cloud_queue_rounded);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(itemId: item.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Фото вещи
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'item_outfit_${item.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(item.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade100,
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.grey.shade400,
                          size: 32,
                        ),
                      ),
                    ),
                    // Лёгкий градиент внизу
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 30,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Информационная часть
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Название вещи
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.3,
                        color: Colors.black87,
                      ),
                    ),

                    // Цветовая точка + подкатегория
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorValue,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            item.subCategory ?? item.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Плашки сезона и стиля
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            warmthIcon,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.style,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}