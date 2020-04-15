import 'package:collectio/util/function/enum_helper.dart';
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
    this.firstName,
    this.lastName,
    this.country,
    this.profileImg,
    @required this.userUid,
    @required this.username,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        country: enumFromString<Country>(json['country'], Country.values),
        profileImg: json['profileImg'],
        userUid: json['userUid'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'country': country != null ? enumToString(country) : '',
        'profileImg': profileImg ?? '',
        'userUid': userUid,
        'username': username,
      };

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
