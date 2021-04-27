import 'package:flutter/foundation.dart';

enum CollectioIAPId {
  collectiopremiumcollection1,
  collectiopremiumcollection5,
  collectiopremiumcollection10,
}

class CollectioIAPProduct {
  final CollectioIAPId id;
  final int value;

  const CollectioIAPProduct._(this.id, this.value);

  factory CollectioIAPProduct.fromStringId(String sId) {
    final CollectioIAPId id = CollectioIAPId.values
        .firstWhere((CollectioIAPId iapId) => describeEnum(iapId) == sId);

    int value;
    switch (id) {
      case CollectioIAPId.collectiopremiumcollection1:
        value = 1;
        break;
      case CollectioIAPId.collectiopremiumcollection5:
        value = 5;
        break;
      case CollectioIAPId.collectiopremiumcollection10:
        value = 10;
        break;
    }

    return CollectioIAPProduct._(id, value);
  }

  @override
  String toString() {
    return 'CollectioIAPProduct($id, $value)';
  }
}
