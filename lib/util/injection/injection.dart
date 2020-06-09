/// Main file that cares of injection using
/// get_it and injectable libraries.

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.iconfig.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) => $initGetIt(getIt, environment: env);
