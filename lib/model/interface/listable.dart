/// Classes that extends Listable can be used inside CollectioList.
abstract class Listable {
  String get id;
  String get title;
  String get subtitle;
  String get thumbnail;
  bool get isPremium;
}
