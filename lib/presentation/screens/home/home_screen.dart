import 'package:flutter/material.dart';
import '../../../../data/models/weather_model.dart';
import '../../../../data/services/weather_service.dart';
import 'widgets/weather_card.dart';
import 'widgets/outfit_card.dart';
import '../../widgets/custom_dropdown.dart';
import '../../../core/user_prefs.dart';
import '../../../core/constants.dart';
import '../../../core/services/gemini_service.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/database/app_database.dart';
import '../../../main.dart';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  WeatherForecast? _weather;
  bool _isLoading = false;
  String? _error;

  late String _currentCity;

  String _activity = 'Прогулка';
  bool _isLongOutside = false;
  bool _isOfficial = false;

  bool _isGenerating = false;
  Map<String, ClothingItem?>? _generatedOutfit;
  String? _outfitDescription;

  @override
  void initState() {
    super.initState();
    _currentCity = UserPrefs.city;
    _loadWeather();
    _loadSavedOutfit();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _weatherService.getWeather(_currentCity);
      setState(() {
        _weather = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCityDialog() {
    final controller = TextEditingController(text: _currentCity);
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 10,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filteredCities = AppConstants.belarusCities
                .where(
                  (city) =>
                      city.toLowerCase().contains(searchQuery.toLowerCase()),
                )
                .toList();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ваш город",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Введите название города для точного прогноза погоды.",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: controller,
                    onChanged: (value) {
                      setModalState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Например: Брест",
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Theme.of(context).primaryColor,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (searchQuery.isEmpty) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children:
                            [
                              'Минск',
                              'Гомель',
                              'Брест',
                              'Витебск',
                              'Гродно',
                              'Могилёв',
                            ].map((city) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ActionChip(
                                  label: Text(
                                    city,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  onPressed: () {
                                    controller.text = city;
                                    setModalState(() => searchQuery = city);
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ] else ...[
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 168),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = filteredCities[index];
                              return ListTile(
                                title: Text(
                                  city,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_outward,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  controller.text = city;
                                  setModalState(() => searchQuery = '');
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "Отмена",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              setState(
                                () => _currentCity = controller.text.trim(),
                              );
                              UserPrefs.setCity(_currentCity);
                              Navigator.pop(ctx);
                              _loadWeather();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Сохранить",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadSavedOutfit() async {
    final timestamp = UserPrefs.lastOutfitTimestamp;
    final jsonStr = UserPrefs.lastOutfitJson;

    if (timestamp != null && jsonStr != null) {
      final savedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final difference = DateTime.now().difference(savedTime);

      if (difference.inHours < 4) {
        try {
          final result = jsonDecode(jsonStr);
          final allItems = await db.select(db.clothingItems).get();

          ClothingItem? findItem(int? id) {
            if (id == null) return null;
            try {
              return allItems.firstWhere((item) => item.id == id);
            } catch (e) {
              return null;
            }
          }

          if (mounted) {
            setState(() {
              _generatedOutfit = {
                'top': findItem(result['top_id']),
                'bottom': findItem(result['bottom_id']),
                'shoes': findItem(result['shoes_id']),
                'outerwear': findItem(result['outerwear_id']),
                'accessory': findItem(result['accessory_id']),
              };
              _outfitDescription = result['description'];
            });
          }
        } catch (e) {
          await UserPrefs.clearLastOutfit();
        }
      } else {
        await UserPrefs.clearLastOutfit();
      }
    }
  }

  Future<void> _generateOutfit() async {
    if (_weather == null) {
      AppSnackBar.showError(context, 'Дождитесь загрузки погоды');
      return;
    }

    final allItems = await db.select(db.clothingItems).get();
    if (allItems.isEmpty) {
      AppSnackBar.showError(context, 'Ваш гардероб пуст. Добавьте вещи!');
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final result = await GeminiService.generateOutfit(
        wardrobe: allItems,
        temperature: _weather!.current.temp,
        condition: _weather!.current.description,
        activity: _activity,
        isLongOutside: _isLongOutside,
        isOfficial: _isOfficial,
      );

      if (!mounted) return;

      if (result != null) {
        ClothingItem? findItem(int? id) {
          if (id == null) return null;
          try {
            return allItems.firstWhere((item) => item.id == id);
          } catch (e) {
            return null;
          }
        }

        setState(() {
          _generatedOutfit = {
            'top': findItem(result['top_id']),
            'bottom': findItem(result['bottom_id']),
            'shoes': findItem(result['shoes_id']),
            'outerwear': findItem(result['outerwear_id']),
            'accessory': findItem(result['accessory_id']),
          };
          _outfitDescription = result['description'];
        });

        final newOutfit = OutfitsCompanion(
          date: drift.Value(DateTime.now()),
          description: drift.Value(result['description']),
          topId: drift.Value(result['top_id']),
          bottomId: drift.Value(result['bottom_id']),
          shoesId: drift.Value(result['shoes_id']),
          outerwearId: drift.Value(result['outerwear_id']),
          accessoryId: drift.Value(result['accessory_id']),
          isFavorite: const drift.Value(false),
        );

        await db.insertOutfit(newOutfit);

        await UserPrefs.setLastOutfitJson(jsonEncode(result));
        await UserPrefs.setLastOutfitTimestamp(
          DateTime.now().millisecondsSinceEpoch,
        );

        AppSnackBar.showSuccess(context, 'Образ успешно подобран!');
      } else {
        AppSnackBar.showError(context, 'Не удалось сгенерировать образ');
      }
    } catch (e) {
      AppSnackBar.showError(context, 'Ошибка: $e');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          WeatherCard(
            forecast: _weather,
            isLoading: _isLoading,
            errorMessage: _error,
            onChangeCity: _showCityDialog,
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdown(
                  label: "Куда собираетесь?",
                  value: _activity,
                  items: const [
                    'Работа',
                    'Прогулка',
                    'Спорт',
                    'Свидание',
                    'Путешествие',
                    'Другое',
                  ],
                  onChanged: (val) => setState(() => _activity = val!),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildToggle(
                      "Больше на улице",
                      _isLongOutside,
                      (v) => setState(() => _isLongOutside = v),
                    ),
                    const SizedBox(width: 10),
                    _buildToggle(
                      "Строгий дресс-код",
                      _isOfficial,
                      (v) => setState(() => _isOfficial = v),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Рекомендованный образ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF002984)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _generateOutfit,
                    icon: _isGenerating
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
                      _isGenerating ? "ИИ думает..." : "Подобрать с помощью ИИ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                OutfitCard(
                  outfit: _generatedOutfit,
                  description: _outfitDescription,
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, bool value, Function(bool) onChanged) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: value ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: value
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: value
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (value) ...[
                const Icon(Icons.check, color: Colors.white, size: 16),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: value ? Colors.white : Colors.black87,
                    fontSize: 13,
                    fontWeight: value ? FontWeight.bold : FontWeight.w500,
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
