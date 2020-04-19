import 'package:collectio/app/bloc/collections/new_collection_bloc.dart';
import 'package:collectio/app/screen/collections/new/widget/new_collection_form.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: NewCollectionForm(),
      ),
    );
  }
}
