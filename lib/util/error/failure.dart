import 'package:equatable/equatable.dart';

import '../constant/translation.dart';

export 'auth_failure.dart';
export 'data_failure.dart';
export 'validation_failure.dart';

/// The most general failure. Think twice before
/// checking for this kind of failure, always prefer
/// failures extending this class.
abstract class Failure extends Equatable {
  final Translation message;

  const Failure({this.message});

  @override
  List<Object> get props => [message];
}
