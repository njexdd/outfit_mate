import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final List items; // Можно типизировать как List<String>, если там всегда строки
  final Function(String?) onChanged;
  final String label;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600, // Чуть мягче, чем bold
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          // Немного уменьшен vertical padding для более аккуратного вида
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // Сделали границу чуть мягче и толще (1.5) для премиального вида
            border: Border.all(color: Colors.grey.shade200, width: 1.5), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04), // Более мягкая тень
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              // КРИТИЧНОЕ ИСПРАВЛЕНИЕ: Ограничиваем высоту меню, чтобы оно не на весь экран
              menuMaxHeight: 300, 
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400, // Более мягкий цвет иконки
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 8, // Чуть больше тени у самого выпадающего списка
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              items: items.map((e) {
                return DropdownMenuItem<String>(
                  value: e.toString(),
                  child: Text(
                    e.toString(),
                    overflow: TextOverflow.ellipsis, // Защита от слишком длинного текста
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}