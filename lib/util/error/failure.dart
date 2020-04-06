import 'package:equatable/equatable.dart';

export 'auth_failure.dart';
export 'validation_failure.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message});

  @override
  List<Object> get props => [message];
}
