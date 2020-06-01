import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/new_item_bloc.dart';
import 'widgets/new_item_form.dart';

class NewItemScreen extends StatelessWidget {
  final Collection collection;

  const NewItemScreen({@required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add item to ${collection.owner}\'s ${collection.id}',
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 12),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            getIt<NewItemBloc>()..add(InitializeNewItemEvent(collection)),
        child: const NewItemForm(),
      ),
    );
  }
}
