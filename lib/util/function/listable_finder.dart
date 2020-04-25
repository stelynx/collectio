import 'package:collectio/model/interface/listable.dart';

class ListableFinder {
  static Listable findById(List<Listable> list, String id) {
    for (Listable element in list) {
      if (element.id == id) return element;
    }
    return null;
  }
}
