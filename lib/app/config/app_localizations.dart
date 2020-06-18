import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../util/constant/language.dart';
import '../../util/constant/translation.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _translations;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Locale localeFromLangugage(Language language) =>
      Locale(describeEnum(language));

  static List<Locale> get supportedLocales => Language.values
      .map((Language language) => localeFromLangugage(language))
      .toList();

  Future<bool> load() async {
    final String jsonString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _translations = jsonMap.map((String key, dynamic value) =>
        MapEntry<String, String>(key, value.toString()));

    return true;
  }

  String translate(Translation key) {
    return _translations[describeEnum(key)];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .map((Locale locale) => locale.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
