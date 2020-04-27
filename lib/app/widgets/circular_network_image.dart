import 'package:flutter/material.dart';

class CircularNetworkImage extends StatelessWidget {
  final String _url;
  final double _radius;

  const CircularNetworkImage(this._url, {double radius = 40.0})
      : _radius = radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: _radius,
      backgroundImage: _url != null ? NetworkImage(_url) : null,
      backgroundColor: _url == null ? Colors.transparent : Colors.red,
    );
  }
}
