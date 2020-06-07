import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@prod
@lazySingleton
class SystemInformation {
  Brightness getBrightness() =>
      SchedulerBinding.instance.window.platformBrightness;
}

@test
@lazySingleton
@RegisterAs(SystemInformation)
class MockedSystemInformation extends Mock implements SystemInformation {}
