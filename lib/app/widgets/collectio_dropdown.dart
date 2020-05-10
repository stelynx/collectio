import 'package:flutter/material.dart';

class CollectioDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String hint;
  final void Function(T) onChanged;
  final Icon icon;

  const CollectioDropdown({
    @required this.value,
    @required this.items,
    @required this.hint,
    @required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: DropdownButton(
          icon: icon,
          isDense: true,
          isExpanded: true,
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
        ),
      ),
    );
  }
}
