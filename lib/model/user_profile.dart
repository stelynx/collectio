import 'package:meta/meta.dart';

import '../util/constant/country.dart';

class UserProfile {
  String email;
  String firstName;
  String lastName;
  Country country;
  String profileImg;
  String userUid;
  String username;

  UserProfile({
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.country,
    @required this.profileImg,
    @required this.userUid,
    @required this.username,
  });

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    final UserProfile typedOther = other;
    return userUid == typedOther.userUid;
  }

  @override
  int get hashCode => userUid.hashCode;
}
