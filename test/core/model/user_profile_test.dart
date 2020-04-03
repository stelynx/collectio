import 'package:collectio/core/model/user_profile.dart';
import 'package:collectio/core/utils/constant/enum/country.dart';
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
}
