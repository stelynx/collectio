import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CollectioToggle extends StatelessWidget {
  final String description;
  final VoidCallback onToggled;
  final bool initialValue;
  final Widget icon;
  final Color activeBackgroundColor;
  final Color activeHandleColor;

  const CollectioToggle({
    @required this.description,
    @required this.onToggled,
    this.initialValue = false,
    this.icon,
    this.activeBackgroundColor,
    this.activeHandleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: onToggled,
      title: Row(
        children: <Widget>[
          if (icon != null) ...[icon],
          Text(description),
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
