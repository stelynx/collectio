import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/constant/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should two UserProfile instances with same userUid be equal', () {
    final UserProfile userProfile1 = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
    );
    final UserProfile userProfile2 = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
    );

    expect(userProfile1, equals(userProfile2));
  });

  test('should two UserProfile instances with same userUid have same hash code',
      () {
    final UserProfile userProfile1 = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
    );
    final UserProfile userProfile2 = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
    );

    expect(userProfile1.hashCode, equals(userProfile2.hashCode));
  });

  test('should get correct JSON from toJson()', () {
    final UserProfile userProfile = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
      premiumCollectionsAvailable: 1,
    );
    final Map<String, dynamic> userProfileJson = <String, dynamic>{
      'email': 'a@b.co',
      'firstName': 'firstName',
      'lastName': 'lastName',
      'country': 'SI',
      'profileImg': '',
      'userUid': '123456',
      'username': 'username',
      'premiumCollectionsAvailable': 1,
    };

    final Map<String, dynamic> result = userProfile.toJson();

    expect(result, equals(userProfileJson));
  });

  test('should get correct UserProfile from UserProfile.fromJson()', () {
    final UserProfile userProfile = UserProfile(
      email: 'a@b.co',
      firstName: 'firstName',
      lastName: 'lastName',
      country: Country.SI,
      profileImg: '',
      userUid: '123456',
      username: 'username',
    );
    final Map<String, dynamic> userProfileJson = <String, dynamic>{
      'email': 'a@b.co',
      'firstName': 'firstName',
      'lastName': 'lastName',
      'country': 'SI',
      'profileImg': '',
      'userUid': '123456',
      'username': 'username',
    };

    final UserProfile result = UserProfile.fromJson(userProfileJson);

    expect(result, equals(userProfile));
  });

  test('should give 0 premium collections by default', () {
    final UserProfile userProfile =
        UserProfile(email: 'a@b.co', userUid: '123456', username: 'username');

    expect(userProfile.premiumCollectionsAvailable, equals(0));
  });
}
