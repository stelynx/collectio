import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/profile/profile_facade.dart';
import '../../../model/user_profile.dart';
import '../../../util/error/data_failure.dart';
import '../auth/auth_bloc.dart';
import '../in_app_purchase/in_app_purchase_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Bloc used to hold profile data of current user.
/// Another bloc should be created for getting profile
/// data of other users in upcoming version.
@prod
@lazySingleton
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileFacade _profileFacade;
  final AuthBloc _authBloc;
  final InAppPurchaseBloc _iapBloc;
  StreamSubscription _authBlocStreamSubscription;
  StreamSubscription _iapBlocStreamSubscription;

  ProfileBloc({
    @required ProfileFacade profileFacade,
    @required AuthBloc authBloc,
    @required InAppPurchaseBloc inAppPurchaseBloc,
  })  : _profileFacade = profileFacade,
        _authBloc = authBloc,
        _iapBloc = inAppPurchaseBloc {
    _authBlocStreamSubscription = _authBloc.listen((AuthState state) {
      if (state is AuthenticatedAuthState) {
        this.add(GetUserProfileEvent(userUid: state.userUid));
      } else if (state is UnauthenticatedAuthState) {
        this.add(ResetUserProfileEvent());
      }
    });
    _iapBlocStreamSubscription = _iapBloc.listen((InAppPurchaseState state) {
      if (state.purchaseState == InAppPurchasePurchaseState.success) {
        this.changePremiumCollectionsAvailable(
            by: state.purchasedProduct.value);
      }
    });
  }

  @override
  Future<void> close() {
    _authBlocStreamSubscription.cancel();
    _iapBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ResetUserProfileEvent) {
      yield EmptyProfileState();
      return;
    }

    yield LoadingProfileState();

    if (event is GetUserProfileEvent) {
      final Either<DataFailure, UserProfile> profileOrFailure =
          await _profileFacade.getUserProfileByUserUid(
              userUid: event.userUid ??
                  (_authBloc.state as AuthenticatedAuthState).userUid);

      yield profileOrFailure.fold(
        (DataFailure failure) => ErrorProfileState(failure),
        (UserProfile profile) => CompleteProfileState(profile),
      );
    } else if (event is AddUserProfileEvent) {
      Either<DataFailure, void> nullOrFailure =
          await _profileFacade.addUserProfile(userProfile: event.userProfile);

      yield nullOrFailure.fold(
        (DataFailure failure) => ErrorProfileState(failure),
        (_) => CompleteProfileState(event.userProfile),
      );
    }
  }

  Future<bool> changePremiumCollectionsAvailable({@required int by}) async {
    if (by < 0 && !canCreatePremiumCollection()) return false;

    final UserProfile userProfile = (state as CompleteProfileState).userProfile;
    userProfile.premiumCollectionsAvailable =
        max(-1, userProfile.premiumCollectionsAvailable + by);

    final Either<DataFailure, void> result =
        await _profileFacade.addUserProfile(userProfile: userProfile);

    this.add(GetUserProfileEvent());

    return result.isRight();
  }

  bool canCreatePremiumCollection() {
    if (!(state is CompleteProfileState)) return false;

    final UserProfile user = (state as CompleteProfileState).userProfile;
    return user.premiumCollectionsAvailable != 0;
  }
}

@test
@lazySingleton
@RegisterAs(ProfileBloc)
class MockedProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}
