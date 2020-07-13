import 'package:flutter/material.dart';

import '../../model/interface/listable.dart';
import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';
import 'circular_network_image.dart';
import 'collectio_dialog.dart';

class CollectioList<T extends Listable> extends StatelessWidget {
  final List<T> items;
  final void Function(T) onTap;
  final void Function(T) onDismiss;
  final Translation dialogText;
  final bool fullScreen;

  const CollectioList({
    @required this.items,
    @required this.onTap,
    this.onDismiss,
    this.dialogText,
    this.fullScreen = false,
  }) : assert(onDismiss == null || dialogText != null);

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
                  size: CollectioStyle.bigIconSize,
                ),
                CollectioStyle.itemSplitter,
                Text(AppLocalizations.of(context)
                    .translate(Translation.noItems)),
              ],
            ),
          )
        : Container(
            height: fullScreen ? double.infinity : null,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                if (onDismiss == null) {
                  return CollectioListTile(
                    title: items[index].title,
                    subtitle: items[index].subtitle,
                    image: items[index].thumbnail,
                    isPremium: items[index].isPremium,
                    onTap: () => onTap(items[index]),
                  );
                }

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    final CollectioDeleteDialog dialog = CollectioDeleteDialog(
                      title: items[index].title,
                      content:
                          AppLocalizations.of(context).translate(dialogText),
                      primaryAction: () => onDismiss(items[index]),
                    );

                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => dialog,
                    );
                  },
                  dismissThresholds: <DismissDirection, double>{
                    DismissDirection.endToStart: 0.25,
                  },
                  background: Container(
                    decoration: BoxDecoration(color: Colors.red),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  child: CollectioListTile(
                    title: items[index].title,
                    subtitle: items[index].subtitle,
                    image: items[index].thumbnail,
                    isPremium: items[index].isPremium,
                    onTap: () => onTap(items[index]),
                  ),
                );
              },
            ),
          );
  }
}

class CollectioListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final bool isPremium;
  final VoidCallback onTap;

  CollectioListTile({
    @required this.title,
    @required this.subtitle,
    @required this.image,
    @required this.isPremium,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircularNetworkImage(
        image,
        radius: 25,
        showPremium: isPremium,
        premiumBackgroundColor: Theme.of(context).backgroundColor,
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
