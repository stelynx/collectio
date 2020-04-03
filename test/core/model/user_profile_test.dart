import 'package:collectio/core/model/user_profile.dart';
import 'package:collectio/core/utils/constant/enum/country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be able to equate two UserProfile instances', () {
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
}
