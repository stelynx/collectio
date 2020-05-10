import 'dart:io';

import 'package:collectio/app/widgets/collectio_image_picker.dart';
import 'package:collectio/platform/image_selector.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.test);

  Widget makeTestableWidget(BuildContext context, File thumbnail) =>
      MaterialApp(
        home: CollectioImagePicker(
          imageSelector: getIt<ImageSelector>(),
          parentContext: context,
          aspectRatio: 1 / 1,
          thumbnail: thumbnail,
          croppedImageHandler: null,
        ),
      );

  testWidgets('should have an icon if thumbnail is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(null, null));

    final Finder iconFinder = find.byType(Icon);

    expect(iconFinder, findsOneWidget);
  });
}
