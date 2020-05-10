import 'dart:io';

import 'package:flutter/material.dart';

import '../../platform/image_selector.dart';

class CollectioImagePicker extends StatelessWidget {
  final ImageSelector _imageSelector;

  final BuildContext parentContext;
  final double aspectRatio;
  final File thumbnail;
  final void Function(File) croppedImageHandler;

  const CollectioImagePicker({
    @required ImageSelector imageSelector,
    @required this.parentContext,
    @required this.aspectRatio,
    @required this.thumbnail,
    @required this.croppedImageHandler,
  })  : assert(aspectRatio == 1 / 1 || aspectRatio == 16 / 9),
        _imageSelector = imageSelector;

  void _getImage(Future<File> Function() imageGetter) async {
    final File image = await imageGetter();

    File croppedImage;
    if (aspectRatio == 1 / 1)
      croppedImage = await _imageSelector.cropThumbnailImage(image.path);
    else if (aspectRatio == 16 / 9)
      croppedImage = await _imageSelector.cropItemImage(image.path);
    croppedImageHandler(croppedImage);
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
        child: thumbnail == null
            ? Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              )
            : Image.file(thumbnail),
      ),
    );
  }
}
