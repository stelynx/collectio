import 'package:equatable/equatable.dart';

export 'auth_failure.dart';
export 'validation_failure.dart';

/// The most general failure. Think twice before
/// checking for this kind of failure, always prefer
/// failures extending this class.
abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message});

  @override
  List<Object> get props => [message];
}
