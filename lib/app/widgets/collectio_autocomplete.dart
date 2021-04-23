import 'dart:async';

import 'package:collectio/app/theme/theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';
import '../theme/style.dart';
import 'collectio_text_field.dart';

typedef FutureOr<Iterable<T>> SearchCallback<T>(String value);

class CollectioAutocompleteField<T> extends StatelessWidget {
  final String labelText;
  final void Function(T) onItemSelected;
  final SearchCallback<T> onQueryChanged;
  final Future<List<T>> Function() suggestionsInitializer;
  final T initialValue;
  final IconData baseFieldSuffixIcon;
  final IconData autocompleteFieldSuffixIcon;

  const CollectioAutocompleteField({
    @required this.labelText,
    @required this.onItemSelected,
    @required this.onQueryChanged,
    this.suggestionsInitializer,
    this.initialValue,
    this.baseFieldSuffixIcon,
    this.autocompleteFieldSuffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CollectioTextField(
      labelText: labelText,
      initialValue: initialValue?.toString(),
      icon: baseFieldSuffixIcon,
      showCursor: false,
      readOnly: true,
      onTap: () async {
        final T selection = await Navigator.of(context).push<T>(
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider<AutocompleteBloc>(
                create: (BuildContext context) {
                  return AutocompleteBloc<T>(
                    onQueryChanged: onQueryChanged,
                    suggestionsInitializer: suggestionsInitializer,
                    initialValue: initialValue,
                  );
                },
                child: CollectioAutocompleteScreen<T>(
                  labelText: labelText,
                  autocompleteFieldSuffixIcon: autocompleteFieldSuffixIcon,
                ),
              );
            },
            fullscreenDialog: true,
          ),
        );

        onItemSelected(selection);
      },
    );
  }
}

class CollectioAutocompleteScreen<T> extends StatelessWidget {
  final String labelText;
  final IconData autocompleteFieldSuffixIcon;

  const CollectioAutocompleteScreen({
    @required this.labelText,
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
              onPressed: () => Navigator.of(context).pop<T>(),
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
                  labelText: labelText?.toString(),
                  icon: Icons.search,
                  initialValue: state.query,
                  onChanged: (String value) => context
                      .bloc<AutocompleteBloc>()
                      .add(QueryChangedAutocompleteEvent(value)),
                ),
              ),

              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child:
                    Image.asset(CollectioThemeManager.poweredByGoogleImagePath),
              ),

              // Results
              if (state.error != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: CollectioStyle.bigIconSize / 2),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.error,
                        size: CollectioStyle.bigIconSize,
                        color: Theme.of(context).errorColor,
                      ),
                      Text(state.error.toString()),
                    ],
                  ),
                ),
              ] else if (state.suggestions == null) ...[
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
                          .translate(Translation.autocompleteNoText)),
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
  final T initialValue;

  AutocompleteBloc({
    @required this.onQueryChanged,
    this.initialValue,
    Future<List<T>> Function() suggestionsInitializer,
  }) {
    this.add(InitializeAutocompleteEvent<T>(suggestionsInitializer));
  }

  @override
  AutocompleteState get initialState => AutocompleteState.initial(
        initialValue: initialValue,
      );

  @override
  Stream<AutocompleteState> mapEventToState(
    AutocompleteEvent event,
  ) async* {
    if (event is InitializeAutocompleteEvent<T>) {
      yield state.copyWith(isLoading: true);

      try {
        final List<T> initialSuggestions = await event.suggestionsInitializer();

        yield state.copyWith(
          suggestions: initialSuggestions,
          isLoading: false,
        );
      } catch (e) {
        yield state.copyWith(isLoading: false, error: e);
      }
    }
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

class InitializeAutocompleteEvent<T> extends AutocompleteEvent {
  final Future<List<T>> Function() suggestionsInitializer;

  const InitializeAutocompleteEvent(this.suggestionsInitializer);
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
    T initialValue,
  }) =>
      AutocompleteState(
        query: initialValue != null ? initialValue.toString() : '',
        suggestions: null,
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
