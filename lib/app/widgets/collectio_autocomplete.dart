import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';
import 'collectio_text_field.dart';

typedef FutureOr<List<T>> SearchCallback<T>(String value);

class CollectioAutocompleteField<T> extends StatelessWidget {
  final void Function(T) onItemSelected;
  final SearchCallback<T> onQueryChanged;
  final List<T> initialSuggestions;
  final T initialValue;
  final IconData baseFieldSuffixIcon;
  final IconData autocompleteFieldSuffixIcon;

  const CollectioAutocompleteField({
    @required this.onItemSelected,
    @required this.onQueryChanged,
    this.initialSuggestions,
    this.initialValue,
    this.baseFieldSuffixIcon,
    this.autocompleteFieldSuffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CollectioTextField(
      labelText:
          AppLocalizations.of(context).translate(Translation.fieldNameLocation),
      initialValue: initialValue.toString(),
      icon: baseFieldSuffixIcon,
      showCursor: false,
      readOnly: true,
      onTap: () async {
        final T selection = await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (_) => BlocProvider<AutocompleteBloc>(
              create: (BuildContext context) => AutocompleteBloc<T>(
                onQueryChanged: onQueryChanged,
                initialSuggestions: initialSuggestions,
                initialValue: initialValue,
              ),
              child: CollectioAutocompleteScreen<T>(
                autocompleteFieldSuffixIcon: autocompleteFieldSuffixIcon,
              ),
            ),
          ),
        );

        onItemSelected(selection);
      },
    );
  }
}

class CollectioAutocompleteScreen<T> extends StatelessWidget {
  final IconData autocompleteFieldSuffixIcon;

  const CollectioAutocompleteScreen({
    this.autocompleteFieldSuffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutocompleteBloc, AutocompleteState>(
      builder: (BuildContext context, AutocompleteState state) => Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.close,
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Search field
              Padding(
                padding: CollectioStyle.screenPadding,
                child: CollectioTextField(
                  labelText: AppLocalizations.of(context)
                      .translate(Translation.fieldNameLocation),
                  icon: state.query.length == 0 ? Icons.search : null,
                  onChanged: (String value) {
                    print('here');
                    context
                        .bloc<AutocompleteBloc>()
                        .add(QueryChangedAutocompleteEvent(value));
                  },
                ),
              ),

              // Results
              if (state.suggestions == null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: CollectioStyle.bigIconSize / 2),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard,
                        size: CollectioStyle.bigIconSize,
                      ),
                      Text(AppLocalizations.of(context)
                          .translate(Translation.cancel)),
                    ],
                  ),
                ),
              ] else if (state.suggestions.length == 0) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: CollectioStyle.bigIconSize / 2),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          color: Colors.amber,
                          size: CollectioStyle.bigIconSize,
                        ),
                        Text(AppLocalizations.of(context)
                            .translate(Translation.noItems)),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.suggestions.length,
                    itemBuilder: (BuildContext context, int index) => ListTile(
                      title: Text(state.suggestions[index].toString()),
                      onTap: () => Navigator.of(context)
                          .pop<T>(state.suggestions[index]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AutocompleteBloc<T> extends Bloc<AutocompleteEvent, AutocompleteState> {
  final SearchCallback<T> onQueryChanged;
  final List<T> initialSuggestions;
  final T initialValue;

  AutocompleteBloc({
    @required this.onQueryChanged,
    this.initialSuggestions,
    this.initialValue,
  });

  @override
  AutocompleteState get initialState => AutocompleteState.initial(
        initialSuggestions: initialSuggestions,
        initialValue: initialValue,
      );

  @override
  Stream<AutocompleteState> mapEventToState(
    AutocompleteEvent event,
  ) async* {
    print(event);
    if (event is QueryChangedAutocompleteEvent) {
      yield state.copyWith(query: event.query, isLoading: true);

      try {
        final List<T> results = await onQueryChanged(event.query);
        yield state.copyWith(
          suggestions: results,
          isLoading: false,
        );
      } catch (e) {
        yield state.copyWith(isLoading: false, error: e);
      }
    }
  }
}

abstract class AutocompleteEvent {
  const AutocompleteEvent();
}

class QueryChangedAutocompleteEvent extends AutocompleteEvent {
  final String query;

  const QueryChangedAutocompleteEvent(this.query);
}

class AutocompleteState<T> extends Equatable {
  final String query;
  final List<T> suggestions;
  final bool isLoading;
  final Object error;

  const AutocompleteState({
    @required this.query,
    @required this.suggestions,
    @required this.isLoading,
    @required this.error,
  });

  factory AutocompleteState.initial({
    List<T> initialSuggestions,
    T initialValue,
  }) =>
      AutocompleteState(
        query: initialValue ?? '',
        suggestions: initialSuggestions,
        isLoading: false,
        error: null,
      );

  AutocompleteState copyWith({
    String query,
    List<T> suggestions,
    bool isLoading,
    Object error,
  }) =>
      AutocompleteState(
        query: query ?? this.query,
        suggestions: suggestions ?? this.suggestions,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  @override
  List<Object> get props => [query, suggestions, isLoading, error];
}
