import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import 'add_item_screen.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/dialog_helper.dart';

class ItemDetailScreen extends StatelessWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  Future _deleteItem(BuildContext context, ClothingItem item) async {
    final bool confirm = await DialogHelper.showDeleteConfirmation(
      context: context,
      title: "Удалить вещь?",
      description:
          "Вы уверены, что хотите удалить \"${item.name}\"? Это действие нельзя отменить.",
    );

    if (confirm) {
      await db.deleteItem(item.id);
      final file = File(item.imagePath);
      if (await file.exists()) await file.delete();

      if (context.mounted) {
        AppSnackBar.showSuccess(context, 'Вещь удалена');
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ClothingItem>(
      stream: db.watchItem(itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("Вещь не найдена")));
        }

        final item = snapshot.data!;
        final colorValue = item.color.length == 8
            ? Color(int.parse(item.color, radix: 16))
            : Colors.grey;
        final warmthText = item.warmthLevel == 3
            ? "Зима"
            : (item.warmthLevel == 1 ? "Лето" : "Демисезон");
        final warmthIcon = item.warmthLevel == 3
            ? Icons.ac_unit
            : (item.warmthLevel == 1 ? Icons.wb_sunny : Icons.cloud);

        // Фирменные цвета приложения
        const gradientStart = Color(0xFF4A90E2);
        const gradientEnd = Color(0xFF002984);

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Stack(
            children: [
              // ── Белая подложка снизу (чтобы не было серого при прокрутке) ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.65,
                child: const ColoredBox(color: Colors.white),
              ),

              // ── Фото вещи (верхняя половина) ──────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.52,
                child: Hero(
                  tag: 'item_${item.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(item.imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            const Color(0xFFF5F7FA).withValues(alpha: 0.6),
                            const Color(0xFFF5F7FA),
                          ],
                          stops: const [0.0, 0.35, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Нижняя карточка с деталями ─────────────────────────────────
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.43,
                    bottom: 40,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 24,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 28.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag indicator
                        Center(
                          child: Container(
                            width: 44,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // ── Категория + дата ───────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Категория — фирменный градиент
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [gradientStart, gradientEnd],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradientStart.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),

                            // Дата добавления
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${item.createdAt.day.toString().padLeft(2, '0')}.${item.createdAt.month.toString().padLeft(2, '0')}.${item.createdAt.year}",
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Название ───────────────────────────────────────
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),

                        if (item.subCategory != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.subCategory!,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // ── Карточки Сезон + Стиль ─────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(warmthIcon, "Сезон", warmthText),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.style_outlined,
                                "Стиль",
                                item.style,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ── Карточка Цвет ──────────────────────────────────
                        _buildColorCard(colorValue),

                        const SizedBox(height: 28),

                        // ── Кнопки действий ───────────────────────────────
                        Row(
                          children: [
                            // Редактировать — фирменный градиент
                            Expanded(
                              flex: 3,
                              child: Builder(
                                builder: (ctx) => GestureDetector(
                                  onTap: () => Navigator.push(
                                    ctx,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddItemScreen(itemToEdit: item),
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [gradientStart, gradientEnd],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: gradientStart.withValues(
                                              alpha: 0.4),
                                          blurRadius: 14,
                                          offset: const Offset(0, 7),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit_outlined,
                                            color: Colors.white, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          "Редактировать",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Удалить — аутлайн
                            Expanded(
                              flex: 2,
                              child: Builder(
                                builder: (ctx) => GestureDetector(
                                  onTap: () => _deleteItem(ctx, item),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.redAccent.withValues(
                                            alpha: 0.4),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                              alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.delete_outline,
                                            color: Colors.redAccent, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          "Удалить",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Кнопка «Назад» ─────────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                child: _buildCircleButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 20),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    const gradientStart = Color(0xFF4A90E2);
    const gradientEnd = Color(0xFF002984);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EDF5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка с фирменным градиентом
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientStart.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9BA3B2),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1A1D26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard(Color colorValue) {
    const gradientStart = Color(0xFF4A90E2);

    // Определяем, светлый ли цвет вещи
    final luminance = colorValue.computeLuminance();
    final isLight = luminance > 0.5;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EDF5), width: 1),
      ),
      child: Row(
        children: [
          // Иконка-пипетка с фирменным градиентом
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [gradientStart, Color(0xFF002984)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientStart.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.colorize_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Основной цвет",
                style: TextStyle(
                  color: Color(0xFF9BA3B2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Выбранный оттенок",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1D26),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Цветной кружок с тенью в цвет вещи
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorValue,
              shape: BoxShape.circle,
              border: Border.all(
                color: isLight
                    ? Colors.grey.shade300
                    : Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorValue.withValues(alpha: 0.45),
                  blurRadius: 14,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}