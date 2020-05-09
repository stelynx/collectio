import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../platform/image_selector.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/new_collection_bloc.dart';
import 'widget/new_collection_form.dart';

class NewCollectionScreen extends StatelessWidget {
  const NewCollectionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new collection'),
      ),
      body: BlocProvider(
        create: (context) => getIt<NewCollectionBloc>(),
        child: NewCollectionForm(
          imageSelector: getIt<ImageSelector>(),
        ),
      ),
    );
  }
}
