import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CollectioTypeAheadField extends StatelessWidget {
  final SuggestionsCallback suggestionsCallback;
  final Widget Function(BuildContext, String) itemBuilder;
  final void Function(String) onSuggestionSelected;
  final String text;

  CollectioTypeAheadField({
    @required this.suggestionsCallback,
    @required this.itemBuilder,
    @required this.onSuggestionSelected,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: suggestionsCallback,
      itemBuilder: itemBuilder,
      onSuggestionSelected: onSuggestionSelected,
      textFieldConfiguration: TextFieldConfiguration(
        controller: text == null
            ? null
            : TextEditingController.fromValue(TextEditingValue(text: text)),
      ),
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
      loadingBuilder: null,
      noItemsFoundBuilder: null,
      errorBuilder: null,
      transitionBuilder: (_, Widget suggestionsBox, __) => suggestionsBox,
      hideSuggestionsOnKeyboardHide: false,
    );
  }
}
