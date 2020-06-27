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
  final CameraPosition _cameraPosition;

  ItemDetailsScreen(this.item)
      : _cameraPosition = item.imageMetadata != null &&
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
    return Dismissible(
      key: Key('item_details_screen_key'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Scaffold(
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
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
