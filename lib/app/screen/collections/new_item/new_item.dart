import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../platform/image_selector.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/new_item_bloc.dart';
import 'widgets/new_item_form.dart';

class NewItemScreen extends StatelessWidget {
  final String owner;
  final String collectionName;

  const NewItemScreen({@required this.owner, @required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add item to $owner\'s $collectionName',
          maxLines: 2,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 12),
        ),
      ),
      body: BlocProvider(
        create: (context) => getIt<NewItemBloc>()
          ..add(InitializeNewItemEvent(
            owner: owner,
            collection: collectionName,
          )),
        child: NewItemForm(
          imageSelector: getIt<ImageSelector>(),
        ),
      ),
    );
  }
}
