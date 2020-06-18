import 'package:flutter/material.dart';

import '../../../../model/collection_item.dart';
import '../../../../util/constant/translation.dart';
import '../../../config/app_localizations.dart';
import '../../../theme/style.dart';
import '../../../widgets/collectio_dropdown.dart';
import '../../../widgets/collectio_text_field.dart';

class ItemDetailsScreen extends StatelessWidget {
  final CollectionItem item;

  const ItemDetailsScreen(this.item);

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
              child: Column(
                children: <Widget>[
                  //Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(item.imageUrl),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
