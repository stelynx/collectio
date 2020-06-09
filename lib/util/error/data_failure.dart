import 'package:collectio/util/error/failure.dart';

/// Used massively to denote that something during
/// data retrieval or data persistence went rotten.
class DataFailure extends Failure {
  const DataFailure({String message}) : super(message: message);
}
