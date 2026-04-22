import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import '../../../core/user_prefs.dart';
import '../../widgets/custom_dropdown.dart';
import '../../../core/utils/snackbar_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _city = UserPrefs.city;
  String _gender = UserPrefs.gender;
  String _ageGroup = UserPrefs.ageGroup;
  double _coldSensitivity = UserPrefs.coldSensitivity;
  String _style = UserPrefs.style;
  String _colorPalette = UserPrefs.colorPalette;

  void _updateSettings() {
    UserPrefs.setCity(_city);
    UserPrefs.setGender(_gender);
    UserPrefs.setAgeGroup(_ageGroup);
    UserPrefs.setColdSensitivity(_coldSensitivity);
    UserPrefs.setStyle(_style);
    UserPrefs.setColorPalette(_colorPalette);

    AppSnackBar.showSuccess(context, 'Настройки сохранены');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),

            const Text(
              "Настройки",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF002984)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OutfitMate AI",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Ваш персональный стилист",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader("Личные данные"),
            _buildSettingsCard(
              child: Column(
                children: [
                  CustomDropdown(
                    label: "Город",
                    value: _city,
                    items: AppConstants.belarusCities,
                    onChanged: (val) {
                      setState(() => _city = val!);
                      _updateSettings();
                    },
                  ),
                  const Divider(height: 32),
                  CustomDropdown(
                    label: "Пол",
                    value: _gender,
                    items: const ['Мужской', 'Женский'],
                    onChanged: (val) {
                      setState(() => _gender = val!);
                      _updateSettings();
                    },
                  ),
                  const Divider(height: 32),
                  CustomDropdown(
                    label: "Возраст",
                    value: _ageGroup,
                    items: const ['До 20', '20-30', '30-40', '40+'],
                    onChanged: (val) {
                      setState(() => _ageGroup = val!);
                      _updateSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader("Предпочтения для ИИ"),
            _buildSettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Чувствительность к холоду",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _coldSensitivity,
                    min: 1,
                    max: 3,
                    divisions: 2,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) => setState(() => _coldSensitivity = val),
                    onChangeEnd: (val) => _updateSettings(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Мерзляк",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "Нормально",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "Жарко",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  CustomDropdown(
                    label: "Предпочитаемый стиль",
                    value: _style,
                    items: AppConstants.styles,
                    onChanged: (val) {
                      setState(() => _style = val!);
                      _updateSettings();
                    },
                  ),
                  const Divider(height: 32),
                  CustomDropdown(
                    label: "Любимая палитра",
                    value: _colorPalette,
                    items: AppConstants.colorPalettes,
                    onChanged: (val) {
                      setState(() => _colorPalette = val!);
                      _updateSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "OutfitMate v1.0.0",
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
