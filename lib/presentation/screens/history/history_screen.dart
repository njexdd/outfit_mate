import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../widgets/expandable_description.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<int, ClothingItem> _itemsMap = {};
  bool _isLoadingItems = true;

  @override
  void initState() {
    super.initState();
    _loadAllItems();
  }

  Future<void> _loadAllItems() async {
    final items = await db.getAllItems();
    if (mounted) {
      setState(() {
        _itemsMap = {for (var item in items) item.id: item};
        _isLoadingItems = false;
      });
    }
  }

  String _formatPrettyDate(DateTime date) {
    const months = [
      'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня',
      'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'
    ];
    return "${date.day} ${months[date.month - 1]}";
  }

  String _getWeekDay(DateTime date) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[date.weekday - 1];
  }

  Future<void> _deleteOutfit(int id) async {
    final bool confirm = await DialogHelper.showDeleteConfirmation(
      context: context,
      title: "Удалить образ?",
      description: "Этот образ исчезнет из истории навсегда. Вы уверены?",
    );

    if (confirm) {
      await db.deleteOutfit(id);
      if (mounted) {
        AppSnackBar.showSuccess(context, 'Образ удален из истории');
      }
    }
  }

  Future _toggleFavorite(Outfit outfit) async {
    final newValue = !outfit.isFavorite;
    await db.toggleFavorite(outfit.id, newValue);

    if (mounted) {
      AppSnackBar.showSuccess(
        context,
        newValue ? 'Образ добавлен в избранное' : 'Образ убран из избранного',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── ЗАГОЛОВОК ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "История",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // ── СПИСОК ─────────────────────────────────────────────────
            Expanded(
              child: _isLoadingItems
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<List<Outfit>>(
                      stream: db.watchAllOutfits(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final outfits = snapshot.data!;

                        // ПУСТОЕ СОСТОЯНИЕ
                        if (outfits.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withValues(alpha: 0.1),
                                        blurRadius: 24,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.history_edu_rounded,
                                    size: 64,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  "История пуста",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Здесь будут появляться образы,\nкоторые подберет для вас ИИ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: outfits.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final outfit = outfits[index];
                            return _buildHistoryCard(outfit);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Outfit outfit) {
    final List<ClothingItem> itemsInOutfit = [];
    if (outfit.topId != null && _itemsMap.containsKey(outfit.topId))
      itemsInOutfit.add(_itemsMap[outfit.topId]!);
    if (outfit.bottomId != null && _itemsMap.containsKey(outfit.bottomId))
      itemsInOutfit.add(_itemsMap[outfit.bottomId]!);
    if (outfit.shoesId != null && _itemsMap.containsKey(outfit.shoesId))
      itemsInOutfit.add(_itemsMap[outfit.shoesId]!);
    if (outfit.outerwearId != null && _itemsMap.containsKey(outfit.outerwearId))
      itemsInOutfit.add(_itemsMap[outfit.outerwearId]!);
    if (outfit.accessoryId != null && _itemsMap.containsKey(outfit.accessoryId))
      itemsInOutfit.add(_itemsMap[outfit.accessoryId]!);

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
          // ── БЛОК ОПИСАНИЯ (идентичен OutfitCard) ──────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 10, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade100, width: 1.5),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Декоративная кавычка
                Positioned(
                  right: 0,
                  top: -10,
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 70,
                    color: Theme.of(context)
                        .primaryColor
                        .withValues(alpha: 0.04),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Дата + кнопки действий в одной строке
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Плашка с датой
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${_formatPrettyDate(outfit.date)} · ${_getWeekDay(outfit.date)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Кнопки лайк + удалить
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _toggleFavorite(outfit),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(
                                          scale: anim, child: child),
                                  child: Icon(
                                    outfit.isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey(outfit.isFavorite),
                                    color: outfit.isFavorite
                                        ? const Color(0xFFFF4757)
                                        : Colors.grey.shade300,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _deleteOutfit(outfit.id),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Описание от стилиста
                    if (outfit.description != null &&
                        outfit.description!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Theme.of(context).primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Совет стилиста",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 14, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3,
                            ),
                          ),
                        ),
                        child: ExpandableDescription(
                            text: outfit.description!),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ── СЕТКА ВЕЩЕЙ (как в OutfitCard/wardrobe) ───────────────
          if (itemsInOutfit.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 12) / 2;
                  final cardHeight = cardWidth / 0.73;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: itemsInOutfit
                        .map(
                          (item) => SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: _buildItemTile(item),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// Тайл вещи — полностью идентичен wardrobe / OutfitCard
  Widget _buildItemTile(ClothingItem item) {
    final colorValue = item.color.length == 8
        ? Color(int.parse(item.color, radix: 16))
        : Colors.grey.shade300;

    final warmthIcon = item.warmthLevel == 3
        ? Icons.ac_unit_rounded
        : (item.warmthLevel == 1
            ? Icons.wb_sunny_rounded
            : Icons.cloud_queue_rounded);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Фото
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(item.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.grey.shade400,
                      size: 28,
                    ),
                  ),
                ),
                // Лёгкий градиент внизу фото
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 28,
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

          // Информация
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Название
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      letterSpacing: -0.3,
                      color: Colors.black87,
                    ),
                  ),

                  // Цветовая точка + подкатегория
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorValue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item.subCategory ?? item.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
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
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Icon(
                          warmthIcon,
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            item.style,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 10,
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
    );
  }
}