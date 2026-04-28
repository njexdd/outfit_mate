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

  bool _isWeatherFromCache = false;

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
      final result = await _weatherService.getWeather(_currentCity);
      setState(() {
        _weather = result.forecast;
        _isWeatherFromCache = result.isFromCache;
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
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final filteredCities = AppConstants.belarusCities
                .where(
                  (city) =>
                      city.toLowerCase().contains(searchQuery.toLowerCase()),
                )
                .toList();

            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20 + keyboardHeight,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Drag-индикатор ──────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Заголовок с иконкой ─────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF002984)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF4A90E2,
                              ).withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ваш город",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Выберите город из списка",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Поле поиска ─────────────────────────────────────
                  TextField(
                    onChanged: (value) {
                      setModalState(() => searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: "Поиск города...",
                      prefixIcon: Icon(
                        Icons.search_rounded,
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

                  // ── Быстрые чипы (только при закрытой клавиатуре) ───
                  if (searchQuery.isEmpty && keyboardHeight == 0) ...[
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
                              'Могилев',
                            ].map((city) {
                              final isSelected = city == _currentCity;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _currentCity = city);
                                    UserPrefs.setCity(city);
                                    Navigator.pop(ctx);
                                    _loadWeather();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFF4A90E2),
                                                Color(0xFF002984),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: isSelected
                                          ? null
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF4A90E2,
                                                ).withValues(alpha: 0.35),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      city,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Список городов ──────────────────────────────────
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: keyboardHeight > 0 ? 130.0 : 220.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        removeBottom: true,
                        child: filteredCities.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Город не найден',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: filteredCities.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  final city = filteredCities[index];
                                  final isSelected = city == _currentCity;
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 2,
                                    ),
                                    title: Text(
                                      city,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF4A90E2),
                                                  Color(0xFF002984),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                          )
                                        : Icon(
                                            Icons.arrow_outward_rounded,
                                            size: 16,
                                            color: Colors.grey.shade400,
                                          ),
                                    onTap: () {
                                      setState(() => _currentCity = city);
                                      UserPrefs.setCity(city);
                                      Navigator.pop(ctx);
                                      _loadWeather();
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Кнопка «Отмена» ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Отмена",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            );
          },
        );
      },
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
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          '${e.toString().replaceFirst('Exception: ', '')}',
        );
      }
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
            isOffline: _isWeatherFromCache, // <-- новое
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
            gradient: value
                ? const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF002984)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: value ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: value
                ? null
                : Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: value
                ? [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
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
