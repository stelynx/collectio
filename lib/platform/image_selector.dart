import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@prod
@lazySingleton
class ImageSelector {
  Future<File> takeImageWithCamera() async {
    File f = await ImagePicker.pickImage(source: ImageSource.camera);
    print(f.path);
    return f;
  }

  Future<File> getImageFromPhotos() async {
    File f = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(f.path);
    return f;
  }

  Future<File> cropThumbnailImage(String source) async {
    File f = await ImageCropper.cropImage(
        sourcePath: source,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: androidUiSettings,
        iosUiSettings: iosUiSettings);

    print(f.path);
    return f;
  }

  Future<File> cropItemImage(String source) async {
    File f = await ImageCropper.cropImage(
        sourcePath: source,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        androidUiSettings: androidUiSettings,
        iosUiSettings: iosUiSettings);

    print(f.path);
    return f;
  }
}

AndroidUiSettings androidUiSettings =
    AndroidUiSettings(toolbarTitle: 'Crop image');

IOSUiSettings iosUiSettings = IOSUiSettings(title: 'Crop image');

@test
@lazySingleton
@RegisterAs(ImageSelector)
class MockedImageSelector extends Mock implements ImageSelector {}
