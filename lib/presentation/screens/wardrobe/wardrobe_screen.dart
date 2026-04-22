import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

import '../../../data/database/app_database.dart';
import '../../../main.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';
import '../../../core/constants.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  String _filterCategory = 'Все';
  String? _filterStyle;
  int? _filterWarmth;

  final List<String> _categories = ['Все', ...AppConstants.categories];
  final List<String> _styles = AppConstants.styles;

  Stream<List<ClothingItem>> _getItemsStream() {
    return (db.select(db.clothingItems)
          ..where((t) {
            drift.Expression<bool> predicate = const drift.Constant(true);

            if (_filterCategory != 'Все') {
              predicate = predicate & t.category.equals(_filterCategory);
            }
            if (_filterStyle != null) {
              predicate = predicate & t.style.equals(_filterStyle!);
            }
            if (_filterWarmth != null) {
              predicate = predicate & t.warmthLevel.equals(_filterWarmth!);
            }
            return predicate;
          })
          ..orderBy([
            (t) => drift.OrderingTerm(
              expression: t.createdAt,
              mode: drift.OrderingMode.desc,
            ),
          ]))
        .watch();
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_filterCategory != 'Все') count++;
    if (_filterStyle != null) count++;
    if (_filterWarmth != null) count++;
    return count;
  }

  String _getFilterSummary() {
    List<String> active = [];
    if (_filterCategory != 'Все') active.add(_filterCategory);
    if (_filterWarmth == 1) active.add('Лето');
    if (_filterWarmth == 2) active.add('Деми');
    if (_filterWarmth == 3) active.add('Зима');
    if (_filterStyle != null) active.add(_filterStyle!);

    if (active.isEmpty) return 'Все вещи';
    return active.join(', ');
  }

  void _showFilterBottomSheet() {
    String tempCategory = _filterCategory;
    String? tempStyle = _filterStyle;
    int? tempWarmth = _filterWarmth;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Фильтры",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempCategory = 'Все';
                              tempStyle = null;
                              tempWarmth = null;
                            });
                          },
                          child: const Text(
                            "Сбросить все",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    const Text(
                      "Категория",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final isSelected = tempCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected)
                              setModalState(() => tempCategory = cat);
                          },
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Сезонность",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip(
                          "Лето",
                          1,
                          tempWarmth,
                          (v) => setModalState(() => tempWarmth = v ? 1 : null),
                        ),
                        _buildFilterChip(
                          "Демисезон",
                          2,
                          tempWarmth,
                          (v) => setModalState(() => tempWarmth = v ? 2 : null),
                        ),
                        _buildFilterChip(
                          "Зима",
                          3,
                          tempWarmth,
                          (v) => setModalState(() => tempWarmth = v ? 3 : null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Стиль",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _styles.map((style) {
                        return _buildFilterChip(
                          style,
                          style,
                          tempStyle,
                          (v) =>
                              setModalState(() => tempStyle = v ? style : null),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _filterCategory = tempCategory;
                            _filterStyle = tempStyle;
                            _filterWarmth = tempWarmth;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Показать результаты",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    dynamic value,
    dynamic groupValue,
    Function(bool) onSelected,
  ) {
    final isSelected = groupValue == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
      checkmarkColor: Theme.of(context).primaryColor,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF002984)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          label: const Text(
            "Добавить",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),

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
                    "Гардероб",
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
                      Icons.checkroom,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _getFilterSummary(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: _showFilterBottomSheet,
                    icon: const Icon(Icons.tune, size: 20),
                    label: Text(
                      _activeFiltersCount > 0
                          ? "Фильтры ($_activeFiltersCount)"
                          : "Фильтры",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: StreamBuilder<List<ClothingItem>>(
                stream: _getItemsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text("Ошибка: ${snapshot.error}"));

                  final items = snapshot.data ?? [];

                  if (items.isEmpty) {
                    // Два разных состояния: фильтры активны vs гардероб реально пустой
                    final bool hasFilters = _activeFiltersCount > 0;
                  
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
                                ),
                              ],
                            ),
                            child: Icon(
                              hasFilters ? Icons.search_off_rounded : Icons.checkroom_outlined,
                              size: 64,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            hasFilters ? "Ничего не найдено" : "Гардероб пуст",
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            hasFilters
                                ? "Попробуйте изменить\nпараметры фильтров"
                                : "Добавьте первую вещь,\nнажав кнопку ниже",
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

                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 180,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.73,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        _buildClothingCard(items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClothingCard(ClothingItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailScreen(itemId: item.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            Expanded(
              child: Hero(
                tag: 'item_${item.id}',
                child: Image.file(
                  File(item.imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[100],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: item.color.length == 8
                              ? Color(int.parse(item.color, radix: 16))
                              : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 0.5,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          item.warmthLevel == 3
                              ? Icons.ac_unit
                              : (item.warmthLevel == 1
                                    ? Icons.wb_sunny
                                    : Icons.cloud),
                          size: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.style,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
