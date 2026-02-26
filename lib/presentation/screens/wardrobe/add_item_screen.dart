import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../data/database/app_database.dart';
import '../../../main.dart';
import '../../widgets/custom_dropdown.dart';
import '../../../core/utils/snackbar_helper.dart';

class AddItemScreen extends StatefulWidget {
  final ClothingItem? itemToEdit;

  const AddItemScreen({super.key, this.itemToEdit});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  File? _imageFile;
  String? _existingImagePath;
  final ImagePicker _picker = ImagePicker();

  String _selectedCategory = 'Верх';
  String? _selectedSubCategory;
  double _warmthLevel = 2.0;
  String _selectedStyle = 'Casual';
  Color _currentColor = Colors.black;

  final List<String> _categories = [
    'Верх',
    'Низ',
    'Обувь',
    'Верхняя одежда',
    'Аксессуары',
  ];
  final List<String> _styles = [
    'Casual',
    'Спорт',
    'Деловой',
    'Гранж',
    'Домашний',
  ];

  final Map<String, List<String>> _subCategoriesMap = {
    'Верх': ['Футболка', 'Рубашка', 'Свитер', 'Худи', 'Пиджак', 'Топ'],
    'Низ': ['Джинсы', 'Брюки', 'Шорты', 'Юбка', 'Спортивки'],
    'Обувь': ['Кроссовки', 'Туфли', 'Ботинки', 'Сапоги', 'Сандалии'],
    'Верхняя одежда': ['Куртка', 'Пальто', 'Тренч', 'Пуховик', 'Ветровка'],
    'Аксессуары': ['Шапка', 'Шарф', 'Кепка', 'Ремень', 'Сумка', 'Перчатки'],
  };

  @override
  void initState() {
    super.initState();

    if (widget.itemToEdit != null) {
      final item = widget.itemToEdit!;
      _nameController.text = item.name;
      _existingImagePath = item.imagePath;
      _selectedCategory = item.category;

      if (_subCategoriesMap[item.category]!.contains(item.subCategory)) {
        _selectedSubCategory = item.subCategory;
      } else {
        _selectedSubCategory = _subCategoriesMap[item.category]!.first;
      }

      _currentColor = item.color.length == 8
          ? Color(int.parse(item.color, radix: 16))
          : Colors.black;
      _warmthLevel = item.warmthLevel.toDouble();
      _selectedStyle = item.style;
    } else {
      _selectedSubCategory = _subCategoriesMap[_selectedCategory]!.first;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  void _showColorPicker() {
    Color tempColor = _currentColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите цвет'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (Color color) => tempColor = color,
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              pickerAreaBorderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Выбрать'),
              onPressed: () {
                setState(() => _currentColor = tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveItem() async {
    if (_imageFile == null && _existingImagePath == null) {
      AppSnackBar.showError(context, 'Пожалуйста, добавьте фото');
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        String finalImagePath = _existingImagePath ?? '';

        if (_imageFile != null) {
          final appDir = await getApplicationDocumentsDirectory();
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final savedImage = await _imageFile!.copy('${appDir.path}/$fileName');
          finalImagePath = savedImage.path;

          if (_existingImagePath != null) {
            final oldFile = File(_existingImagePath!);
            if (await oldFile.exists()) await oldFile.delete();
          }
        }

        final colorHex = _currentColor
            .toARGB32()
            .toRadixString(16)
            .padLeft(8, '0');

        if (widget.itemToEdit != null) {
          final updatedItem = widget.itemToEdit!.copyWith(
            name: _nameController.text,
            imagePath: finalImagePath,
            category: _selectedCategory,
            subCategory: drift.Value(_selectedSubCategory),
            color: colorHex,
            warmthLevel: _warmthLevel.round(),
            style: _selectedStyle,
          );
          await db.updateItem(updatedItem);

          if (mounted) AppSnackBar.showSuccess(context, 'Вещь обновлена!');
        } else {
          final newItem = ClothingItemsCompanion(
            name: drift.Value(_nameController.text),
            imagePath: drift.Value(finalImagePath),
            category: drift.Value(_selectedCategory),
            subCategory: drift.Value(_selectedSubCategory),
            color: drift.Value(colorHex),
            warmthLevel: drift.Value(_warmthLevel.round()),
            style: drift.Value(_selectedStyle),
            createdAt: drift.Value(DateTime.now()),
          );
          await db.insertItem(newItem);

          if (mounted)
            AppSnackBar.showSuccess(context, 'Вещь успешно добавлена!');
        }

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) AppSnackBar.showError(context, 'Ошибка: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    ImageProvider? imageProvider;
    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (_existingImagePath != null) {
      imageProvider = FileImage(File(_existingImagePath!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Редактировать вещь" : "Добавить вещь"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: 40.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      image: imageProvider != null
                          ? DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: imageProvider == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Добавить фото",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Название вещи",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Введите название' : null,
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: CustomDropdown(
                      label: "Категория",
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val!;
                          _selectedSubCategory =
                              _subCategoriesMap[_selectedCategory]!.first;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomDropdown(
                      label: "Тип",
                      value:
                          _selectedSubCategory ??
                          _subCategoriesMap[_selectedCategory]!.first,
                      items: _subCategoriesMap[_selectedCategory]!,
                      onChanged: (val) =>
                          setState(() => _selectedSubCategory = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                "Основной цвет",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _currentColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _currentColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Выбрать цвет",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.colorize, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                "На какую погоду?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Slider(
                value: _warmthLevel,
                min: 1,
                max: 3,
                divisions: 2,
                label: _warmthLevel == 1
                    ? "Лето"
                    : (_warmthLevel == 2 ? "Демисезон" : "Зима"),
                onChanged: (val) => setState(() => _warmthLevel = val),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Лето"), Text("Деми"), Text("Зима")],
              ),
              const SizedBox(height: 24),

              const Text(
                "Стиль",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _styles.map((style) {
                  final isSelected = _selectedStyle == style;
                  return ChoiceChip(
                    label: Text(style),
                    selected: isSelected,
                    onSelected: (s) {
                      if (s) setState(() => _selectedStyle = style);
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEditing ? "Сохранить изменения" : "Добавить в гардероб",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
