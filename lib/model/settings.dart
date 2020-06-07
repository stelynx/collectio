import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../util/constant/collectio_theme.dart';
import '../util/function/enum_helper.dart';

class Settings extends Equatable {
  final CollectioTheme theme;

  const Settings({
    @required this.theme,
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      Settings(theme: enumFromString(json['theme'], CollectioTheme.values));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme': describeEnum(theme),
      };

  @override
  List<Object> get props => [theme];
}
