import '../constant/translation.dart';
import 'failure.dart';

/// Used massively to denote that something during
/// data retrieval or data persistence went rotten.
class DataFailure extends Failure {
  const DataFailure({Translation message}) : super(message: message);
}
