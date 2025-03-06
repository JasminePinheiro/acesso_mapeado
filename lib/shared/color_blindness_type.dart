import 'package:color_blindness/color_blindness.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderColorBlindnessType extends ChangeNotifier {
  ColorBlindnessType? _currentType;

  ColorBlindnessType? get currentType => _currentType;

  void setCurrentType(ColorBlindnessType type) {
    _currentType = type;
    notifyListeners();
  }

  Future<void> setCurrentTypeFromSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final type = sharedPreferences.getString('colorBlindnessType');
    _currentType = ColorBlindnessType.values.byName(type ?? 'none');
    notifyListeners();
  }

  Future<void> saveCurrentTypeToSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        'colorBlindnessType', getCurrentType().name);
  }

  void clearCurrentType() {
    _currentType = null;
    notifyListeners();
  }

  ColorBlindnessType getCurrentType() {
    return _currentType ?? ColorBlindnessType.none;
  }

  Future<bool> isFirstTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return !sharedPreferences.containsKey('colorBlindnessType');
  }

  String getTranslation(ColorBlindnessType type) {
    switch (type) {
      case ColorBlindnessType.none:
        return 'Nenhum';
      case ColorBlindnessType.protanomaly:
        return 'Protanomalia';
      case ColorBlindnessType.deuteranomaly:
        return 'Deuteranomalia';
      case ColorBlindnessType.tritanomaly:
        return 'Tritanomalia';
      case ColorBlindnessType.protanopia:
        return 'Protanopia';
      case ColorBlindnessType.deuteranopia:
        return 'Deuteranopia';
      case ColorBlindnessType.tritanopia:
        return 'Tritanopia';
      case ColorBlindnessType.achromatopsia:
        return 'Acromatopsia';
      case ColorBlindnessType.achromatomaly:
        return 'Acromatopsia Parcial';
    }
  }
}
