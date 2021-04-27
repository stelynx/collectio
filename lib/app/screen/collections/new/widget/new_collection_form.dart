import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../../model/image_metadata.dart';
import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/translation.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_collection_bloc.dart';
import '../../../../bloc/in_app_purchase/in_app_purchase_bloc.dart';
import '../../../../config/app_localizations.dart';
import '../../../../theme/style.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_dialog.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_section_title.dart';
import '../../../../widgets/collectio_text_field.dart';
import '../../../../widgets/collectio_toast.dart';
import '../../../../widgets/collectio_toggle.dart';
import '../../../../widgets/failure_text.dart';

class NewCollectionForm extends StatelessWidget {
  const NewCollectionForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewCollectionBloc, NewCollectionState>(
      listener: (BuildContext context, NewCollectionState state) {
        if (state.dataFailure != null && state.dataFailure.isRight()) {
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, NewCollectionState state) {
        return Center(
          child: ListView(
            padding: CollectioStyle.screenPadding,
            children: <Widget>[
              // Image
              CollectioImagePicker(
                imageSelector: getIt<ImageSelector>(),
                parentContext: context,
                aspectRatio: 1 / 1,
                thumbnail: state.thumbnail.get(),
                croppedImageHandler: ({
                  @required File image,
                  @required ImageMetadata metadata,
                }) =>
                    context
                        .bloc<NewCollectionBloc>()
                        .add(ImageChangedNewCollectionEvent(image)),
                showError:
                    state.showErrorMessages && !state.thumbnail.isValid(),
              ),

              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,

              // Title
              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.collectionTitle),
                errorText: state.showErrorMessages && !state.title.isValid()
                    ? state.title.value.fold(
                        (ValidationFailure failure) => failure
                                is TitleEmptyValidationFailure
                            ? AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure)
                            : AppLocalizations.of(context)
                                .translate(Translation.titleValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(TitleChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Subtitle
              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.collectionSubtitle),
                errorText: state.showErrorMessages && !state.subtitle.isValid()
                    ? state.subtitle.value.fold(
                        (ValidationFailure failure) =>
                            AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(SubtitleChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Description
              CollectioTextField(
                maxLines: null,
                labelText: AppLocalizations.of(context)
                    .translate(Translation.collectionDescription),
                errorText: state.showErrorMessages &&
                        !state.description.isValid()
                    ? state.description.value.fold(
                        (ValidationFailure failure) => failure
                                is DescriptionEmptyValidationFailure
                            ? AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure)
                            : AppLocalizations.of(context).translate(
                                Translation.descriptionValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(DescriptionChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Is premium?
              BlocConsumer<InAppPurchaseBloc, InAppPurchaseState>(
                listener: (context, iapState) {
                  if (iapState.purchaseState ==
                      InAppPurchasePurchaseState.error) {
                    final SnackBar snackBar = CollectioToast(
                      message: AppLocalizations.of(context)
                          .translate(Translation.inAppPurchaseError),
                      toastType: ToastType.warning,
                    );
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Scaffold.of(context).showSnackBar(snackBar));
                  } else if (iapState.purchaseState ==
                      InAppPurchasePurchaseState.success) {
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
                  if (iapState.purchaseState ==
                      InAppPurchasePurchaseState.pending) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return CollectioToggle(
                    description: AppLocalizations.of(context)
                        .translate(Translation.collectionPremium),
                    onToggled: () {
                      if (!context
                          .bloc<NewCollectionBloc>()
                          .canCreatePremiumCollection()) {
                        if (!iapState.isReady || !iapState.isAvailable) {
                          showDialog(
                            context: context,
                            builder: (context) => CollectioInfoDialog(
                              title: AppLocalizations.of(context).translate(
                                  Translation.inAppPurchaseNotAvailable),
                              content: AppLocalizations.of(context).translate(
                                  Translation.inAppPurchaseNotAvailableContent),
                            ),
                          );
                          return;
                        }

                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            final List<ListTile> iapTiles = iapState
                                .productDetails
                                .map<ListTile>((ProductDetails pd) => ListTile(
                                      title: Text(pd.title),
                                      subtitle: Text(pd.description),
                                      trailing: Text(pd.price),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        context.bloc<InAppPurchaseBloc>().add(
                                            PurchaseInAppPurchaseEvent(pd));
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
                      }

                      context
                          .bloc<NewCollectionBloc>()
                          .add(IsPremiumChangedNewCollectionEvent());
                    },
                    initialValue: state.isPremium,
                    activeBackgroundColor: CollectioStyle.goldColor,
                    activeHandleColor: CollectioStyle.goldColor,
                    icon: Icon(
                      Icons.info,
                      size: 25,
                    ),
                    hintTitle: AppLocalizations.of(context)
                        .translate(Translation.collectionPremium),
                    hintContent: AppLocalizations.of(context)
                        .translate(Translation.collectionPremiumInfo),
                  );
                },
              ),

              CollectioSectionTitle(
                AppLocalizations.of(context)
                    .translate(Translation.fieldNamesSectionTitle),
                sectionDescription: AppLocalizations.of(context)
                    .translate(Translation.fieldNamesSectionDescription),
                parentHasPadding: true,
              ),

              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.fieldNameTitle),
                initialValue: state is InitialNewCollectionState
                    ? state.itemTitleName.get()
                    : null,
                errorText: state.showErrorMessages &&
                        !state.itemTitleName.isValid()
                    ? state.itemTitleName.value.fold(
                        (ValidationFailure failure) =>
                            AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemTitleNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.fieldNameSubtitle),
                initialValue: state is InitialNewCollectionState
                    ? state.itemSubtitleName.get()
                    : null,
                errorText: state.showErrorMessages &&
                        !state.itemSubtitleName.isValid()
                    ? state.itemSubtitleName.value.fold(
                        (ValidationFailure failure) =>
                            AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemSubtitleNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.fieldNameDescription),
                initialValue: state is InitialNewCollectionState
                    ? state.itemDescriptionName.get()
                    : null,
                errorText: state.showErrorMessages &&
                        !state.itemDescriptionName.isValid()
                    ? state.itemDescriptionName.value.fold(
                        (ValidationFailure failure) =>
                            AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure),
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemDescriptionNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              if (state.dataFailure != null && state.dataFailure.isLeft()) ...[
                state.dataFailure.fold(
                  (DataFailure failure) => FailureText(failure.message),
                  null,
                ),
                CollectioStyle.itemSplitter,
              ],

              CollectioStyle.itemSplitter,

              if (state.isSubmitting) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                // Submit
                CollectioButton(
                  onPressed: () => context
                      .bloc<NewCollectionBloc>()
                      .add(SubmitNewCollectionEvent()),
                  text: AppLocalizations.of(context)
                      .translate(Translation.submit),
                  isPrimary: true,
                ),

                CollectioStyle.itemSplitter,

                // Cancel
                CollectioButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: AppLocalizations.of(context)
                      .translate(Translation.cancel),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
