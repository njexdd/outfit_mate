import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import '../../widgets/expandable_description.dart'; // Наш общий виджет
import '../../../core/utils/dialog_helper.dart'; // Наш диалог
import '../../../core/utils/snackbar_helper.dart'; // Наши снекбары

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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

  // Удаляем лайк (образ исчезнет из списка автоматически)
  Future _toggleFavorite(Outfit outfit) async {
  await db.toggleFavorite(outfit.id, false);
  
  if (mounted) {
    AppSnackBar.showSuccess(context, 'Образ убран из избранного');
  }
}

  Future<void> _deleteOutfit(int id) async {
    final bool confirm = await DialogHelper.showDeleteConfirmation(
      context: context,
      title: "Удалить образ?",
      description: "Образ будет удален из истории и избранного навсегда.",
    );

    if (confirm) {
      await db.deleteOutfit(id);
      if (mounted) AppSnackBar.showSuccess(context, 'Образ удален');
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
            // ЗАГОЛОВОК
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Избранное",
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
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded, // Сердечко
                      color: const Color(0xFFFF4757), // Красный цвет
                      size: 28,
                    ),
                  )
                ],
              ),
            ),

            // СПИСОК
            Expanded(
              child: _isLoadingItems
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<List<Outfit>>(
                      stream: db.watchFavoriteOutfits(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final outfits = snapshot.data!;

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
                                        color: const Color(0xFFFF4757).withValues(alpha: 0.1),
                                        blurRadius: 24,
                                        offset: const Offset(0, 12),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite_border, 
                                    size: 64, 
                                    color: Color(0xFFFF4757), 
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  "Нет избранных",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Отмечайте понравившиеся образы\nсердечком в истории",
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
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: outfits.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final outfit = outfits[index];
                            return _buildFavoriteCard(outfit);
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

  Widget _buildFavoriteCard(Outfit outfit) {
    // (Код сборки вещей идентичен, но мы его повторяем, чтобы экран был независимым)
    final List<ClothingItem> itemsInOutfit = [];
    if (outfit.topId != null && _itemsMap.containsKey(outfit.topId)) itemsInOutfit.add(_itemsMap[outfit.topId]!);
    if (outfit.bottomId != null && _itemsMap.containsKey(outfit.bottomId)) itemsInOutfit.add(_itemsMap[outfit.bottomId]!);
    if (outfit.shoesId != null && _itemsMap.containsKey(outfit.shoesId)) itemsInOutfit.add(_itemsMap[outfit.shoesId]!);
    if (outfit.outerwearId != null && _itemsMap.containsKey(outfit.outerwearId)) itemsInOutfit.add(_itemsMap[outfit.outerwearId]!);
    if (outfit.accessoryId != null && _itemsMap.containsKey(outfit.accessoryId)) itemsInOutfit.add(_itemsMap[outfit.accessoryId]!);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4757).withValues(alpha: 0.08), // Красноватая тень
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ВЕРХ
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4757).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 16, color: Color(0xFFFF4757)),
                      const SizedBox(width: 8),
                      Text(
                        _formatPrettyDate(outfit.date),
                        style: const TextStyle(
                          color: Color(0xFFFF4757),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Row(
                  children: [
                    // Кнопка ЛАЙК (Всегда закрашена, нажатие убирает из списка)
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Color(0xFFFF4757), size: 24),
                      onPressed: () => _toggleFavorite(outfit),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20, color: Colors.grey.shade300),
                      onPressed: () => _deleteOutfit(outfit.id),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ОПИСАНИЕ
          if (outfit.description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ExpandableDescription(text: outfit.description!),
            ),
          
          const SizedBox(height: 12),

          // ГАЛЕРЕЯ
          SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: itemsInOutfit.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final item = itemsInOutfit[i];
                return Column(
                  children: [
                    Container(
                      width: 90,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade100,
                        image: DecorationImage(
                          image: FileImage(File(item.imagePath)),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 3))
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 90,
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}