import 'package:flutter/material.dart';

import 'collectio_premium_icon.dart';

class CircularNetworkImage extends StatelessWidget {
  final String _url;
  final double _radius;
  final bool _showPremium;
  final Color _premiumBackgroundColor;

  const CircularNetworkImage(
    this._url, {
    double radius = 40.0,
    bool showPremium = false,
    Color premiumBackgroundColor,
  })  : assert(!showPremium || premiumBackgroundColor != null),
        _radius = radius,
        _showPremium = showPremium,
        _premiumBackgroundColor = premiumBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: _radius,
          backgroundImage: _url != null ? NetworkImage(_url) : null,
          backgroundColor: _url != null
              ? Colors.transparent
              : Theme.of(context).primaryColor,
        ),
        if (_showPremium) ...[
          Positioned(
            child: CollectioPremiumIcon(
              backgroundColor: _premiumBackgroundColor,
              size: _radius / 2,
            ),
            bottom: 0,
            right: 0,
          ),
        ],
      ],
    );
  }
}
