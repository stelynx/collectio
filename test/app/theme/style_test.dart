import 'package:collectio/app/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('textFieldDecoration', () {
    test('should return InputDecoration', () {
      final result = CollectioStyle.textFieldDecoration(
        context: MockedBuildContext(),
        labelText: 'labelText',
      );

      expect(result, isA<InputDecoration>());
    });

    test('should have suffixIcon set when icon supplied', () {
      final InputDecoration result = CollectioStyle.textFieldDecoration(
        context: MockedBuildContext(),
        labelText: 'labelText',
        icon: Icons.input,
      );

      expect(result.suffixIcon, isA<Widget>());
    });
  });
}

class MockedBuildContext extends Mock implements BuildContext {}
