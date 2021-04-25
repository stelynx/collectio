part of 'in_app_purchase_bloc.dart';

abstract class InAppPurchaseEvent {
  const InAppPurchaseEvent();
}

class InitializeInAppPurchaseEvent extends InAppPurchaseEvent {
  const InitializeInAppPurchaseEvent();
}

class PurchaseInAppPurchaseEvent extends InAppPurchaseEvent {
  final ProductDetails productDetails;

  const PurchaseInAppPurchaseEvent(this.productDetails);
}

class PendingInAppPurchaseEvent extends InAppPurchaseEvent {
  const PendingInAppPurchaseEvent();
}

class ErrorInAppPurchaseEvent extends InAppPurchaseEvent {
  final PurchaseDetails purchaseDetails;

  const ErrorInAppPurchaseEvent(this.purchaseDetails);
}

class PurchasedInAppPurchaseEvent extends InAppPurchaseEvent {
  final PurchaseDetails purchaseDetails;

  const PurchasedInAppPurchaseEvent(this.purchaseDetails);
}
