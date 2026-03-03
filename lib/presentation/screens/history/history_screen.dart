import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/dialog_helper.dart';

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

  Future<void> _toggleFavorite(Outfit outfit) async {
    final newValue = !outfit.isFavorite;
    await db.toggleFavorite(outfit.id, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.history,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  )
                ],
              ),
            ),

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
                                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                        blurRadius: 24,
                                        offset: const Offset(0, 12),
                                      )
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.history_edu, 
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
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: outfits.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final outfit = outfits[index];
                            return _buildPremiumHistoryCard(outfit);
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

  Widget _buildPremiumHistoryCard(Outfit outfit) {
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
            color: const Color(0xFF4A90E2).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ВЕРХНЯЯ ЧАСТЬ
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 10, 5), // Чуть изменили отступы
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ДАТА
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "${_formatPrettyDate(outfit.date)} • ${_getWeekDay(outfit.date)}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // КНОПКИ ДЕЙСТВИЙ (ЛАЙК + УДАЛИТЬ)
                Row(
                  children: [
                    // КНОПКА ЛАЙКА
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(outfit.isFavorite), // Ключ для анимации
                          color: outfit.isFavorite ? const Color(0xFFFF4757) : Colors.grey.shade400,
                          size: 24,
                        ),
                      ),
                      onPressed: () => _toggleFavorite(outfit),
                    ),
                    
                    // КНОПКА УДАЛЕНИЯ
                    IconButton(
                      icon: Icon(Icons.close, size: 20, color: Colors.black),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    // ФОТО
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
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          )
                        ],
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // НАЗВАНИЕ (БЕЗ ИКОНКИ)
                    SizedBox(
                      width: 90,
                      child: Text(
                        item.name,
                        textAlign: TextAlign.center, // Центрируем текст под фото
                        style: TextStyle(
                          fontSize: 11, // Сделали чуть крупнее (было 10)
                          color: Colors.grey.shade700, // Чуть темнее
                          fontWeight: FontWeight.w500
                        ),
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

class ExpandableDescription extends StatefulWidget {
  final String text;
  const ExpandableDescription({super.key, required this.text});

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 15,
      height: 1.5,
      color: Colors.grey.shade700,
      fontStyle: FontStyle.italic,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 3,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: textStyle);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                widget.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textStyle,
              ),
              secondChild: Text(
                widget.text,
                style: textStyle,
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              alignment: Alignment.topLeft,
            ),
            
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? "Свернуть" : "Читать далее",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}