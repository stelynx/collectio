import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/injection/injection.dart';
import '../../bloc/auth/sign_in_bloc.dart';
import '../../theme/style.dart';
import 'widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => getIt<SignInBloc>(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/collectio_icon.png',
                height: min(200, MediaQuery.of(context).size.width / 2),
                width: min(200, MediaQuery.of(context).size.height / 2),
              ),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              SignInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
