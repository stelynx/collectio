import 'dart:io';

import 'package:flutter/material.dart';

import '../../model/image_metadata.dart';
import '../../platform/image_selector.dart';
import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';

class CollectioImagePicker extends StatelessWidget {
  final ImageSelector _imageSelector;

  final BuildContext parentContext;
  final double aspectRatio;
  final File thumbnail;
  final void Function({File image, ImageMetadata metadata}) croppedImageHandler;
  final bool isImageLocal;
  final String url;
  final bool showError;

  const CollectioImagePicker({
    @required ImageSelector imageSelector,
    @required this.parentContext,
    @required this.aspectRatio,
    @required this.croppedImageHandler,
    this.thumbnail,
    this.isImageLocal = true,
    this.url,
    this.showError = false,
  })  : assert(aspectRatio == 1 / 1 || aspectRatio == 16 / 9),
        assert(isImageLocal || url != null),
        _imageSelector = imageSelector;

  void _getImage(Future<File> Function() imageGetter) async {
    final File image = await imageGetter();

    if (image == null) return;

    final ImageMetadata imageMetadata =
        await _imageSelector.getImageMetadata(image);

    File croppedImage;
    if (aspectRatio == 1 / 1)
      croppedImage = await _imageSelector.cropThumbnailImage(image.path);
    else if (aspectRatio == 16 / 9)
      croppedImage = await _imageSelector.cropItemImage(image.path);

    if (croppedImage != null)
      croppedImageHandler(image: croppedImage, metadata: imageMetadata);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: parentContext,
          builder: (_) => Container(
            height: 120,
            child: ListView(
              children: <Widget>[
                ListTile(
                  trailing: Icon(Icons.photo_camera),
                  title: Text(AppLocalizations.of(context)
                      .translate(Translation.camera)),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(_imageSelector.takeImageWithCamera);
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.photo_library),
                  title: Text(AppLocalizations.of(context)
                      .translate(Translation.photoLibrary)),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(_imageSelector.getImageFromPhotos);
                  },
                ),
              ],
            ),
          ),
        ),
        child: thumbnail != null
            ? Image.file(thumbnail)
            : (!isImageLocal
                ? Image.network(url)
                : Container(
                    decoration: showError
                        ? BoxDecoration(
                            border:
                                Border.all(color: Theme.of(context).errorColor),
                            borderRadius: CollectioStyle.borderRadius,
                          )
                        : BoxDecoration(
                            border: Border.all(),
                            borderRadius: CollectioStyle.borderRadius,
                          ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: showError
                                ? Theme.of(context).errorColor
                                : Theme.of(context).iconTheme.color,
                          ),
                          if (showError) ...[
                            Text(
                              AppLocalizations.of(context).translate(
                                  Translation.photoValidationFailure),
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }
}
