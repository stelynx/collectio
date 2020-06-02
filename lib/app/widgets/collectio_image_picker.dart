import 'dart:io';

import 'package:flutter/material.dart';

import '../../platform/image_selector.dart';

class CollectioImagePicker extends StatelessWidget {
  final ImageSelector _imageSelector;

  final BuildContext parentContext;
  final double aspectRatio;
  final File thumbnail;
  final void Function(File) croppedImageHandler;
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

    File croppedImage;
    if (aspectRatio == 1 / 1)
      croppedImage = await _imageSelector.cropThumbnailImage(image.path);
    else if (aspectRatio == 16 / 9)
      croppedImage = await _imageSelector.cropItemImage(image.path);

    if (croppedImage != null) croppedImageHandler(croppedImage);
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
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(_imageSelector.takeImageWithCamera);
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.photo_library),
                  title: Text('Photo library'),
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
                                Border.all(color: Theme.of(context).errorColor))
                        : BoxDecoration(border: Border.all()),
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
                              'Please select a photo',
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
