import 'package:flutter/material.dart';

class CollectioLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CollectioLink({
    @required this.text,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        text,
        style: Theme.of(context).textTheme.caption,
      ),
      onTap: onTap,
    );
  }
}
