part of 'in_app_purchase_bloc.dart';

enum InAppPurchasePurchaseState { idle, pending, error, success }

class InAppPurchaseState {
  final bool isReady;
  final bool isAvailable;
  final List<ProductDetails> productDetails;
  final InAppPurchasePurchaseState purchaseState;

  const InAppPurchaseState({
    @required this.isReady,
    @required this.isAvailable,
    @required this.productDetails,
    @required this.purchaseState,
  });

  InAppPurchaseState copyWith({
    bool isReady,
    bool isAvailable,
    List<ProductDetails> productDetails,
    InAppPurchasePurchaseState purchaseState,
  }) =>
      InAppPurchaseState(
        isReady: isReady ?? this.isReady,
        isAvailable: isAvailable ?? this.isAvailable,
        productDetails: productDetails ?? this.productDetails,
        purchaseState: purchaseState ?? this.purchaseState,
      );
}

class InitialInAppPurchaseState extends InAppPurchaseState {
  const InitialInAppPurchaseState()
      : super(
          isReady: false,
          isAvailable: false,
          productDetails: null,
          purchaseState: InAppPurchasePurchaseState.idle,
        );
}
