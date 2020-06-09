import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

/// Provides various data about system the app is running on.
@prod
@lazySingleton
class SystemInformation {
  /// Returns either [Brightness.light] or [Brightness.dark],
  /// depending whether device uses light or dark theme.
  Brightness getBrightness() =>
      SchedulerBinding.instance.window.platformBrightness;
}

@test
@lazySingleton
@RegisterAs(SystemInformation)
class MockedSystemInformation extends Mock implements SystemInformation {}
