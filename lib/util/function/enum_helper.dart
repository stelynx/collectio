import 'package:flutter/foundation.dart';

/// Gets enum value corresponding to [key] from [values].
T enumFromString<T>(String key, List<T> values) =>
    values.firstWhere((v) => key == describeEnum(v), orElse: () => null);
