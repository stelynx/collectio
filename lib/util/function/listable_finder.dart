import 'package:collectio/model/interface/listable.dart';

/// Provides support for finding elements in
/// array of elements that extend Listable interface.
class ListableFinder {
  /// Find element with id [id] in [list].
  static Listable findById(List<Listable> list, String id) {
    for (Listable element in list) {
      if (element.id == id) return element;
    }
    return null;
  }
}
