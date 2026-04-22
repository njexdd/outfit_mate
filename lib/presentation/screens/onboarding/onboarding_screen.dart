import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/user_prefs.dart';
import '../main_navigation_screen.dart';
import '../../../core/utils/snackbar_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String _searchQuery = '';
  String? _selectedCity;
  String _selectedGender = 'Мужской';
  String _selectedAge = '20-30';
  double _coldSensitivity = 2.0;
  String _selectedStyle = 'Casual';
  String _selectedColors = 'Базовые';

  Future<void> _completeOnboarding() async {
    await UserPrefs.setCity(_selectedCity ?? 'Минск');
    await UserPrefs.setGender(_selectedGender);
    await UserPrefs.setAgeGroup(_selectedAge);
    await UserPrefs.setColdSensitivity(_coldSensitivity);
    await UserPrefs.setStyle(_selectedStyle);
    await UserPrefs.setColorPalette(_selectedColors);

    await UserPrefs.setOnboardingComplete();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildStep1Intro(),
                  _buildStep2Location(),
                  _buildStep3Demographics(),
                  _buildStep4Preferences(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(4, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == 1 && _selectedCity == null) {
                AppSnackBar.showError(context, 'Пожалуйста, выберите город');
                return;
              }
              if (_currentPage < 3) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                _completeOnboarding();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _currentPage == 3 ? 'Начать' : 'Далее',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Intro() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom_rounded,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          const Text(
            "OutfitMate",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Ваш персональный ИИ-стилист. Мы подберем идеальный образ из ваших вещей с учетом погоды за окном.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Location() {
    final filteredCities = AppConstants.belarusCities
        .where(
          (city) => city.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Где вы находитесь?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Это нужно для точного прогноза погоды",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: "Поиск города...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                final city = filteredCities[index];
                final isSelected = _selectedCity == city;
                return Card(
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.white,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      city,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () => setState(() => _selectedCity = city),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Demographics() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Немного о вас",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Чтобы образы подходили вам идеально",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),

          const Text(
            "Ваш пол",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSelectCard(
                  "Мужской",
                  Icons.male,
                  _selectedGender == "Мужской",
                  () => setState(() => _selectedGender = "Мужской"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSelectCard(
                  "Женский",
                  Icons.female,
                  _selectedGender == "Женский",
                  () => setState(() => _selectedGender = "Женский"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          const Text(
            "Возраст",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: ["До 20", "20-30", "30-40", "40+"].map((age) {
              final isSelected = _selectedAge == age;
              return ChoiceChip(
                label: Text(age, style: const TextStyle(fontSize: 16)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                selected: isSelected,
                onSelected: (v) {
                  if (v) setState(() => _selectedAge = age);
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Preferences() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ваши предпочтения",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              "Чувствительность к холоду",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Slider(
              value: _coldSensitivity,
              min: 1,
              max: 3,
              divisions: 2,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (val) => setState(() => _coldSensitivity = val),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Мерзляк", style: TextStyle(color: Colors.grey)),
                Text("Нормально", style: TextStyle(color: Colors.grey)),
                Text("Жарко", style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              "Повседневный стиль",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.styles.map((style) {
                final isSelected = _selectedStyle == style;
                return ChoiceChip(
                  label: Text(style),
                  selected: isSelected,
                  onSelected: (v) {
                    if (v) setState(() => _selectedStyle = style);
                  },
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  checkmarkColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            const Text(
              "Любимые цвета",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: AppConstants.colorPalettes.map((
                color,
              ) {
                final isSelected = _selectedColors == color;
                return ChoiceChip(
                  label: Text(color),
                  selected: isSelected,
                  onSelected: (v) {
                    if (v) setState(() => _selectedColors = color);
                  },
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: 0.1),
                  checkmarkColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectCard(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? primaryColor : Colors.grey,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryColor : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
