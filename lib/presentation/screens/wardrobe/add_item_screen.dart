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
import '../../../core/constants.dart';
import '../../../core/services/ai_scanner_service.dart';

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

  final List<String> _categories = AppConstants.categories;
  final List<String> _styles = AppConstants.styles;

  final Map<String, List<String>> _subCategoriesMap =
      AppConstants.subCategoriesMap;

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

  bool _isScanning = false;

  Future<void> _scanItem() async {
    if (_imageFile == null) {
      AppSnackBar.showError(context, 'Сначала выберите фото');
      return;
    }

    setState(() => _isScanning = true);

    try {
      final result = await AiScannerService.analyzeImage(_imageFile!);

      if (result != null) {
        setState(() {
          if (result['name'] != null) _nameController.text = result['name'];
          if (result['category'] != null)
            _selectedCategory = result['category'];
          _selectedSubCategory = null;
          if (result['subCategory'] != null)
            _selectedSubCategory = result['subCategory'];
          if (result['style'] != null) _selectedStyle = result['style'];
          if (result['warmthLevel'] != null)
            _warmthLevel = result['warmthLevel'].toDouble();
          if (result['colorHex'] != null) {
            _currentColor = Color(int.parse(result['colorHex'], radix: 16));
          }
        });
        AppSnackBar.showSuccess(context, 'Вещь распознана!');
      } else {
        AppSnackBar.showError(context, 'Не удалось распознать вещь');
      }
    } on Exception catch (e) {
      AppSnackBar.showError(
        context,
        'Ошибка: ${e.toString().replaceFirst('Exception: ', '')}',
      );
    } finally {
      setState(() => _isScanning = false);
    }
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
    final isEditing = widget.itemToEdit != null; // [cite: 528]

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Фирменный фон
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isEditing ? 'Редактировать вещь' : 'Новая вещь',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildFormCard(),
              const SizedBox(height: 32),
              _buildSaveButton(isEditing),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Секция с фотографией и кнопкой ИИ-сканера
  // Секция с фотографией и кнопкой ИИ-сканера
  Widget _buildImageSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(ImageSource.gallery), //
          child: Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24), // В стиле OutfitCard
              border: _imageFile == null && _existingImagePath == null
                  ? Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ) //
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), //
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : (_existingImagePath != null
                      ? Image.file(File(_existingImagePath!), fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Нажмите, чтобы добавить фото",
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )),
          ),
        ),
        const SizedBox(height: 16),

        // ИСПРАВЛЕНО: Кнопка AI-сканирования теперь с видимым фоном-градиентом
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4A90E2),
                Color(0xFF002984),
              ], // Наш фирменный градиент
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF4A90E2,
                ).withValues(alpha: 0.3), // Легкое свечение
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _isScanning ? null : _scanItem,
            icon: _isScanning
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.auto_awesome, color: Colors.white),
            label: Text(
              _isScanning ? "ИИ анализирует..." : "Распознать с помощью ИИ",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              backgroundColor: Colors
                  .transparent, // Фон прозрачный, чтобы было видно градиент контейнера
              shadowColor: Colors
                  .transparent, // Убираем стандартную тень кнопки, т.к. есть тень у контейнера
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ).copyWith(elevation: WidgetStateProperty.all(0)),
          ),
        ),
      ],
    );
  }

  // Карточка с формой ввода
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), //
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), //
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey, // [cite: 519]
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Название",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController, // [cite: 519]
              decoration: InputDecoration(
                hintText: 'Например: Любимое худи',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Введите название' : null,
            ),
            const SizedBox(height: 20),

            CustomDropdown(
              // [cite: 550]
              label: 'Категория',
              value: _selectedCategory,
              items: _categories.cast<String>(), // [cite: 522]
              onChanged: (val) {
                if (val != null)
                  setState(() {
                    _selectedCategory = val;
                    _selectedSubCategory =
                        _subCategoriesMap[val]?.first; // [cite: 522]
                  });
              },
            ),
            const SizedBox(height: 20),

            if (_selectedSubCategory != null) ...[
              CustomDropdown(
                // [cite: 550]
                label: 'Подкатегория',
                value: _selectedSubCategory!,
                items: _subCategoriesMap[_selectedCategory] ?? [],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSubCategory = val);
                },
              ),
              const SizedBox(height: 20),
            ],

            CustomDropdown(
              // [cite: 550]
              label: 'Стиль',
              value: _selectedStyle,
              items: _styles.cast<String>(), // [cite: 522]
              onChanged: (val) {
                if (val != null) setState(() => _selectedStyle = val);
              },
            ),
            const SizedBox(height: 20),

            // Выбор цвета и теплоты в одном ряду для компактности
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Цвет",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showColorPicker, // [cite: 525]
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: _currentColor, // [cite: 521]
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDropdown(
                    // [cite: 550]
                    label: 'Сезон',
                    value: _warmthLevel == 1
                        ? 'Лето'
                        : (_warmthLevel == 2
                              ? 'Деми'
                              : 'Зима'), // [cite: 541, 542]
                    items: const ['Лето', 'Деми', 'Зима'],
                    onChanged: (val) {
                      setState(() {
                        if (val == 'Лето') _warmthLevel = 1.0;
                        if (val == 'Деми') _warmthLevel = 2.0;
                        if (val == 'Зима') _warmthLevel = 3.0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Кнопка сохранения в стиле FloatingActionButton из WardrobeScreen
  Widget _buildSaveButton(bool isEditing) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          // Фирменный градиент
          colors: [Color(0xFF4A90E2), Color(0xFF002984)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: 0.4), //
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveItem, // [cite: 527]
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          isEditing ? "Сохранить изменения" : "Добавить в гардероб",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
