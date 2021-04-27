import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

import '../../../model/iap_product.dart';

part 'in_app_purchase_event.dart';
part 'in_app_purchase_state.dart';

@prod
@singleton
class InAppPurchaseBloc extends Bloc<InAppPurchaseEvent, InAppPurchaseState> {
  static Set<String> _ids =
      CollectioIAPId.values.map<String>((iapId) => describeEnum(iapId)).toSet();

  final InAppPurchaseConnection _iapConnection;

  StreamSubscription<List<PurchaseDetails>> _subscription;

  InAppPurchaseBloc(this._iapConnection) : super() {
    this.add(InitializeInAppPurchaseEvent());
  }

  @override
  InAppPurchaseState get initialState => InitialInAppPurchaseState();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  Stream<InAppPurchaseState> mapEventToState(
    InAppPurchaseEvent event,
  ) async* {
    if (event is InitializeInAppPurchaseEvent) {
      final bool available = await _iapConnection.isAvailable();
      if (!available) {
        print('not available');
        yield state.copyWith(isAvailable: false, isReady: true);
        return;
      }

      final Stream purchaseUpdated = _iapConnection.purchaseUpdatedStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });

      final ProductDetailsResponse response =
          await _iapConnection.queryProductDetails(_ids);
      print(response.productDetails);
      print(response.notFoundIDs);
      if (response.notFoundIDs.isNotEmpty) {
        yield state.copyWith(isAvailable: false, isReady: true);
        return;
      }

      yield state.copyWith(
        isAvailable: true,
        isReady: true,
        productDetails: response.productDetails,
      );
    } else if (event is PurchaseInAppPurchaseEvent) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: event.productDetails);
      _iapConnection.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } else if (event is PendingInAppPurchaseEvent) {
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.pending);
    } else if (event is ErrorInAppPurchaseEvent) {
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.error);
    } else if (event is PurchasedInAppPurchaseEvent) {
      yield state.copyWith(
        purchaseState: InAppPurchasePurchaseState.success,
        purchasedProduct: event.purchasedProduct,
      );
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.idle);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          this.add(PendingInAppPurchaseEvent());
          break;
        case PurchaseStatus.error:
          if (Platform.isIOS || purchaseDetails.pendingCompletePurchase) {
            await _iapConnection.completePurchase(purchaseDetails);
          }
          this.add(ErrorInAppPurchaseEvent(purchaseDetails));
          break;
        case PurchaseStatus.purchased:
          final CollectioIAPProduct product =
              CollectioIAPProduct.fromStringId(purchaseDetails.productID);

          await _iapConnection.completePurchase(purchaseDetails);
          if (Platform.isAndroid) {
            await _iapConnection.consumePurchase(purchaseDetails);
          }

          this.add(PurchasedInAppPurchaseEvent(product));
          break;
      }
    });
  }
}

@test
@singleton
@RegisterAs(InAppPurchaseBloc)
class MockedInAppPurchaseBloc
    extends MockBloc<InAppPurchaseEvent, InAppPurchaseState>
    implements InAppPurchaseBloc {}
