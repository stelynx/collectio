import 'package:flutter/material.dart';

import '../../util/constant/constants.dart';

class CollectioPremiumIcon extends StatelessWidget {
  final Color backgroundColor;
  final double size;

  const CollectioPremiumIcon({
    @required this.backgroundColor,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: backgroundColor),
        borderRadius: BorderRadius.circular(size),
      ),
      child: Padding(
        padding: EdgeInsets.all(size / 10),
        child: Image.asset(
          Constants.premiumIcon,
          width: size,
          height: size,
        ),
      ),
    );
  }
}
