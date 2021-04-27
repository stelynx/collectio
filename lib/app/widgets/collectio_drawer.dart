import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../util/constant/translation.dart';
import '../../util/injection/injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/in_app_purchase/in_app_purchase_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../config/app_localizations.dart';
import '../routes/routes.dart';
import '../theme/style.dart';
import 'circular_network_image.dart';
import 'collectio_dialog.dart';
import 'collectio_link.dart';
import 'collectio_toast.dart';

class CollectioDrawer extends StatelessWidget {
  const CollectioDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            BlocBuilder<ProfileBloc, ProfileState>(
              bloc: getIt<ProfileBloc>(),
              builder: (BuildContext context, ProfileState state) {
                if (state is CompleteProfileState)
                  return ListTile(
                    title: Text(
                        '${AppLocalizations.of(context).translate(Translation.hello)}, ${state.userProfile.username}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CollectioLink(
                          text: AppLocalizations.of(context)
                              .translate(Translation.viewProfile),
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.profile,
                            arguments: state.userProfile,
                          ),
                        ),
                        SizedBox(width: 10),
                        CollectioLink(
                          text: AppLocalizations.of(context)
                              .translate(Translation.editProfile),
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.editProfile,
                          ),
                        ),
                      ],
                    ),
                    leading: CircularNetworkImage(
                      state.userProfile.profileImg,
                      radius: 25,
                    ),
                  );

                return Row(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)
                        .translate(Translation.loadingProfile)),
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text(AppLocalizations.of(context)
                  .translate(Translation.titleSettings)),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.settings);
              },
            ),
            BlocConsumer<InAppPurchaseBloc, InAppPurchaseState>(
              listener: (context, iapState) {
                if (iapState.purchaseState ==
                    InAppPurchasePurchaseState.error) {
                  Navigator.of(context).pop();
                  final SnackBar snackBar = CollectioToast(
                    message: AppLocalizations.of(context)
                        .translate(Translation.inAppPurchaseError),
                    toastType: ToastType.warning,
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Scaffold.of(context).showSnackBar(snackBar));
                } else if (iapState.purchaseState ==
                    InAppPurchasePurchaseState.success) {
                  Navigator.of(context).pop();
                  final SnackBar snackBar = CollectioToast(
                    message: AppLocalizations.of(context)
                        .translate(Translation.inAppPurchaseSuccessful),
                    toastType: ToastType.success,
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Scaffold.of(context).showSnackBar(snackBar));
                }
              },
              builder: (context, iapState) {
                if (!iapState.isReady || !iapState.isAvailable) {
                  return Container();
                }

                if (iapState.purchaseState ==
                    InAppPurchasePurchaseState.pending) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListTile(
                  dense: true,
                  title: Text(AppLocalizations.of(context)
                      .translate(Translation.buyPremiumCollection)),
                  trailing: Icon(Icons.attach_money),
                  onTap: () {
                    if (!iapState.isReady || !iapState.isAvailable) {
                      showDialog(
                        context: context,
                        builder: (context) => CollectioInfoDialog(
                          title: AppLocalizations.of(context)
                              .translate(Translation.inAppPurchaseNotAvailable),
                          content: AppLocalizations.of(context).translate(
                              Translation.inAppPurchaseNotAvailableContent),
                        ),
                      );
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        final List<ListTile> iapTiles = iapState.productDetails
                            .map<ListTile>((ProductDetails pd) => ListTile(
                                  title: Text(pd.title),
                                  subtitle: Text(pd.description),
                                  trailing: Text(pd.price),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    context
                                        .bloc<InAppPurchaseBloc>()
                                        .add(PurchaseInAppPurchaseEvent(pd));
                                  },
                                ))
                            .toList();
                        return Container(
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  AppLocalizations.of(context).translate(
                                      Translation.availableInAppPurchases),
                                ),
                              ),
                              ...iapTiles,
                            ],
                          ),
                        );
                      },
                    );
                    return;
                  },
                );
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                  AppLocalizations.of(context).translate(Translation.logout)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                context.bloc<AuthBloc>().add(SignedOutAuthEvent());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
              },
            ),
            Spacer(),
            Text(AppLocalizations.of(context).translate(Translation.copyright)),
            CollectioStyle.itemSplitter,
          ],
        ),
      ),
    );
  }
}
