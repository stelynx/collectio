import 'package:flutter/material.dart';

import '../../../../../model/collection.dart';
import '../../../../theme/style.dart';
import '../../../../widgets/circular_network_image.dart';

class CollectionDetailsView extends StatelessWidget {
  final Collection _collection;

  const CollectionDetailsView(this._collection);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: CollectioStyle.elevation,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Row(
          children: <Widget>[
            CircularNetworkImage(_collection.thumbnail),
            SizedBox(width: 20),
            Expanded(
              child: Table(
                columnWidths: {0: FixedColumnWidth(80)},
                children: <TableRow>[
                  TableRow(
                    children: <TableCell>[
                      _buildFirstColumnCell('Title'),
                      _buildSecondColumnCell(_collection.title),
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      _buildFirstColumnCell('Subtitle', center: true),
                      _buildSecondColumnCell(_collection.subtitle),
                    ],
                  ),
                  TableRow(
                    children: <TableCell>[
                      _buildFirstColumnCell('Description', center: true),
                      _buildSecondColumnCell(
                        _collection.description,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableCell _buildFirstColumnCell(String text, {bool center = false}) {
    return TableCell(
      verticalAlignment: center
          ? TableCellVerticalAlignment.middle
          : TableCellVerticalAlignment.bottom,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  TableCell _buildSecondColumnCell(String text, {int maxLines = 1}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.top,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Text(
          text,
          textAlign: TextAlign.start,
          maxLines: maxLines,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
