import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'collectio_dialog.dart';

class CollectioToggle extends StatelessWidget {
  final String description;
  final String hintTitle;
  final String hintContent;
  final VoidCallback onToggled;
  final bool initialValue;
  final Widget icon;
  final Color activeBackgroundColor;
  final Color activeHandleColor;

  const CollectioToggle({
    @required this.description,
    this.hintTitle,
    this.hintContent,
    @required this.onToggled,
    this.initialValue = false,
    this.icon,
    this.activeBackgroundColor,
    this.activeHandleColor,
  }) : assert((icon == null && hintTitle == null && hintContent == null) ||
            (icon != null && hintTitle != null && hintContent != null));

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: onToggled,
      title: Row(
        children: <Widget>[
          Text(description),
          if (icon != null) ...[
            const SizedBox(width: 5.0),
            GestureDetector(
              child: icon,
              onTap: () {
                final CollectioInfoDialog premiumInfoDialog =
                    CollectioInfoDialog(title: hintTitle, content: hintContent);

                showDialog(
                  context: context,
                  builder: (BuildContext context) => premiumInfoDialog,
                );
              },
            ),
          ],
        ],
      ),
      trailing: PlatformSwitch(
        value: initialValue,
        onChanged: (_) => onToggled(),
        cupertino: (_, __) => CupertinoSwitchData(
          activeColor: activeBackgroundColor,
        ),
        material: (_, __) => MaterialSwitchData(
          activeColor: activeBackgroundColor,
          activeTrackColor: activeHandleColor,
        ),
      ),
    );
  }
}
