import 'dart:io';

import 'package:exif/exif.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../model/image_metadata.dart';

/// Provides ability for accessing camera and photo
/// library for image picking and cropping.
@prod
@lazySingleton
class ImageSelector {
  /// Get image via camera.
  Future<File> takeImageWithCamera() =>
      ImagePicker.pickImage(source: ImageSource.camera);

  /// Get image from photo library.
  Future<File> getImageFromPhotos() =>
      ImagePicker.pickImage(source: ImageSource.gallery);

  /// Crop image for collection thumbnail.
  Future<File> cropThumbnailImage(String source) => ImageCropper.cropImage(
        sourcePath: source,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );

  /// Crop image for item image.
  Future<File> cropItemImage(String source) => ImageCropper.cropImage(
        sourcePath: source,
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      );

  /// Gets important image exif data.
  Future<ImageMetadata> getImageMetadata(File image) async {
    try {
      final Map<String, IfdTag> exifData = await readExifFromFile(image);
      return ImageMetadata.fromExif(exifData);
    } catch (_) {
      return null;
    }
  }
}

@test
@lazySingleton
@RegisterAs(ImageSelector)
class MockedImageSelector extends Mock implements ImageSelector {}
