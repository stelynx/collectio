import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/constant/translation.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/new_collection_bloc.dart';
import '../../../config/app_localizations.dart';
import 'widget/new_collection_form.dart';

class NewCollectionScreen extends StatelessWidget {
  const NewCollectionScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)
            .translate(Translation.titleAddCollection)),
      ),
      body: BlocProvider(
        create: (context) => getIt<NewCollectionBloc>(),
        child: const NewCollectionForm(),
      ),
    );
  }
}
