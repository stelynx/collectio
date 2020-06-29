import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../model/collection_item.dart';
import '../../../../util/constant/translation.dart';
import '../../../config/app_localizations.dart';
import '../../../theme/style.dart';
import '../../../widgets/collectio_dropdown.dart';
import '../../../widgets/collectio_text_field.dart';

class ItemDetailsScreen extends StatelessWidget {
  final CollectionItem item;
  final int itemNumber;
  final int numberOfItems;
  final CameraPosition _cameraPosition;

  ItemDetailsScreen({
    @required this.item,
    @required this.itemNumber,
    @required this.numberOfItems,
  }) : _cameraPosition = item.imageMetadata != null &&
                item.imageMetadata.latitude != null &&
                item.imageMetadata.longitude != null
            ? CameraPosition(
                target: LatLng(
                  item.imageMetadata.latitude,
                  item.imageMetadata.longitude,
                ),
                zoom: 5,
              )
            : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '# $itemNumber / $numberOfItems',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: CollectioStyle.screenPadding,
            child: ListView(
              children: <Widget>[
                // Image
                ClipRRect(
                  borderRadius: CollectioStyle.borderRadius,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(item.imageUrl),
                  ),
                ),

                CollectioStyle.itemSplitter,
                CollectioStyle.itemSplitter,

                // Title
                CollectioTextField(
                  labelText: item.parent.itemTitleName,
                  enabled: false,
                  maxLines: null,
                  initialValue: item.title,
                ),

                CollectioStyle.itemSplitter,

                // Subtitle
                CollectioTextField(
                  labelText: item.parent.itemSubtitleName,
                  maxLines: null,
                  enabled: false,
                  initialValue: item.subtitle,
                ),

                CollectioStyle.itemSplitter,

                // Description
                CollectioTextField(
                  maxLines: null,
                  labelText: item.parent.itemDescriptionName,
                  enabled: false,
                  initialValue: item.description,
                ),

                CollectioStyle.itemSplitter,

                // Raiting
                CollectioDropdown<int>(
                  value: item.raiting,
                  items: List<int>.generate(10, (int i) => i + 1),
                  hint: AppLocalizations.of(context)
                      .translate(Translation.raiting),
                  icon: Icon(Icons.star),
                ),

                if (_cameraPosition != null) ...[
                  CollectioStyle.itemSplitter,
                  Container(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: CollectioStyle.borderRadius,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _cameraPosition,
                        markers: <Marker>{
                          Marker(
                            markerId: MarkerId('originalMarker'),
                            position: _cameraPosition.target,
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        },
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => new EagerGestureRecognizer(),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
