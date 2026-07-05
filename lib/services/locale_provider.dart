import 'package:flutter/material.dart';

/// Permet à l'utilisateur de changer de langue (FR / EN / AR)
/// à tout moment depuis n'importe quel écran.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('ar'),
  ];

  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  bool get isRtl => _locale.languageCode == 'ar';
}
