import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String hint;
  final void Function(T) onChanged;
  final IconData icon;
  final bool isExpanded;
  final bool isDense;

  const CollectioDropdown({
    @required this.value,
    @required this.items,
    this.hint = '...',
    this.onChanged,
    this.icon,
    this.isExpanded = true,
    this.isDense = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        width: isExpanded ? null : 150.0,
        padding: icon != null
            ? EdgeInsets.symmetric(horizontal: 15, vertical: 12)
            : EdgeInsets.fromLTRB(15, 8, 5, 8),
        decoration: BoxDecoration(
          border: onChanged == null
              ? Border.all(color: Colors.black54)
              : Border.all(),
          borderRadius: CollectioStyle.borderRadius,
        ),
        child: DropdownButton(
          icon: icon == null
              ? null
              : Icon(
                  icon,
                  size: Theme.of(context).iconTheme.size,
                  color:
                      value != null ? Theme.of(context).iconTheme.color : null,
                ),
          isDense: isDense,
          isExpanded: isExpanded,
          value: value,
          items: items
              .map(
                (T item) => DropdownMenuItem(
                  child: Text(item.toString()),
                  value: item,
                ),
              )
              .toList(),
          onChanged: onChanged,
          hint: Text(hint),
          disabledHint: Text(value.toString()),
        ),
      ),
    );
  }
}
