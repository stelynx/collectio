import 'package:flutter/material.dart';

import '../../util/constant/constants.dart';
import '../theme/style.dart';

class CircularNetworkImage extends StatelessWidget {
  final String _url;
  final double _radius;
  final bool _showPremium;

  const CircularNetworkImage(
    this._url, {
    double radius = 40.0,
    bool showPremium = false,
  })  : _radius = radius,
        _showPremium = showPremium;

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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Theme.of(context).cardColor),
                borderRadius: CollectioStyle.borderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(
                  Constants.premiumIcon,
                  width: _radius / 2,
                  height: _radius / 2,
                ),
              ),
            ),
            bottom: 0,
            right: 0,
          ),
        ],
      ],
    );
  }
}
