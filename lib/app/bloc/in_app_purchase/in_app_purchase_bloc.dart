import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

part 'in_app_purchase_event.dart';
part 'in_app_purchase_state.dart';

@prod
@singleton
class InAppPurchaseBloc extends Bloc<InAppPurchaseEvent, InAppPurchaseState> {
  static const Set<String> _ids = <String>{
    'collectiopremiumcollection1',
    'collectiopremiumcollection5',
    'collectiopremiumcollection10',
  };

  StreamSubscription<List<PurchaseDetails>> _subscription;

  InAppPurchaseBloc() : super() {
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
      print('here');
      final bool available =
          await InAppPurchaseConnection.instance.isAvailable();
      if (!available) {
        print('not available');
        yield state.copyWith(isAvailable: false, isReady: true);
        return;
      }

      final Stream purchaseUpdated =
          InAppPurchaseConnection.instance.purchaseUpdatedStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (error) {
        // handle error here.
      });

      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_ids);
      print(response.productDetails);
      print(response.notFoundIDs);
      if (response.notFoundIDs.isNotEmpty) {
        yield state.copyWith(isAvailable: false, isReady: true);
        return;
      }
      print(response.productDetails);
      yield state.copyWith(
        isAvailable: true,
        isReady: true,
        productDetails: response.productDetails,
      );
    } else if (event is PurchaseInAppPurchaseEvent) {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: event.productDetails);
      InAppPurchaseConnection.instance.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } else if (event is PendingInAppPurchaseEvent) {
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.pending);
    } else if (event is ErrorInAppPurchaseEvent) {
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.error);
    } else if (event is PurchasedInAppPurchaseEvent) {
      yield state.copyWith(purchaseState: InAppPurchasePurchaseState.success);
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          this.add(PendingInAppPurchaseEvent());
          break;
        case PurchaseStatus.error:
          this.add(ErrorInAppPurchaseEvent(purchaseDetails));
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchaseConnection.instance
                .completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.purchased:
          this.add(PurchasedInAppPurchaseEvent(purchaseDetails));
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchaseConnection.instance
                .completePurchase(purchaseDetails);
          }
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
