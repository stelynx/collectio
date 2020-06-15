import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../util/constant/collectio_theme.dart';
import '../util/constant/language.dart';
import '../util/function/enum_helper.dart';

class Settings extends Equatable {
  final CollectioTheme theme;
  final Language language;

  const Settings({
    @required this.theme,
    @required this.language,
  });

  factory Settings.defaults() => Settings(
        theme: CollectioTheme.SYSTEM,
        language: Language.en,
      );

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        theme: enumFromString(json['theme'], CollectioTheme.values),
        language: enumFromString(json['language'], Language.values),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme': describeEnum(theme),
        'language': describeEnum(language),
      };

  @override
  List<Object> get props => [theme, language];
}
