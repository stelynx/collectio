import 'package:flutter/material.dart';

import '../../../../model/collection_item.dart';
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
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  //Image
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(item.imageUrl),
                  ),

                  SizedBox(height: 20),

                  // Title
                  CollectioTextField(
                    labelText: item.parent.itemTitleName,
                    enabled: false,
                    maxLines: null,
                    initialValue: item.title,
                  ),

                  SizedBox(height: 10),

                  // Subtitle
                  CollectioTextField(
                    labelText: item.parent.itemSubtitleName,
                    maxLines: null,
                    enabled: false,
                    initialValue: item.subtitle,
                  ),

                  SizedBox(height: 10),

                  // Description
                  CollectioTextField(
                    maxLines: null,
                    labelText: item.parent.itemDescriptionName,
                    enabled: false,
                    initialValue: item.description,
                  ),

                  SizedBox(height: 10),

                  // Raiting
                  CollectioDropdown<int>(
                    value: item.raiting,
                    items: List<int>.generate(10, (int i) => i + 1),
                    hint: 'Raiting',
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
