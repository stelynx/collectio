import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';

class CollectioTypeAheadField extends StatelessWidget {
  final SuggestionsCallback suggestionsCallback;
  final void Function(String) onSuggestionSelected;
  final String text;
  final IconData icon;

  CollectioTypeAheadField({
    @required this.suggestionsCallback,
    @required this.onSuggestionSelected,
    @required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<String>(
      suggestionsCallback: suggestionsCallback,
      onSuggestionSelected: onSuggestionSelected,
      itemBuilder: (BuildContext context, String value) {
        return ListTile(title: Text(value));
      },
      textFieldConfiguration: TextFieldConfiguration(
        controller: text == null
            ? null
            : TextEditingController.fromValue(TextEditingValue(text: text)),
        autocorrect: false,
        autofocus: false,
        decoration: CollectioStyle.textFieldDecoration(
          context: context,
          labelText: AppLocalizations.of(context)
              .translate(Translation.fieldNameLocation),
          icon: icon,
        ),
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
