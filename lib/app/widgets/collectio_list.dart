import 'package:flutter/material.dart';

import '../../model/interface/listable.dart';
import '../../util/constant/constants.dart';
import 'circular_network_image.dart';

class CollectioList<T extends Listable> extends StatelessWidget {
  final List<T> items;
  final void Function(T) onTap;
  final bool fullScreen;

  const CollectioList({
    @required this.items,
    @required this.onTap,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return items.length == 0
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.amber,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(Constants.noItems),
              ],
            ),
          )
        : Container(
            height: fullScreen ? double.infinity : null,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(items[index].title),
                subtitle: Text(items[index].subtitle),
                leading:
                    CircularNetworkImage(items[index].thumbnail, radius: 25),
                trailing: Icon(Icons.chevron_right),
                onTap: () => onTap(items[index]),
              ),
            ),
          );
  }
}
