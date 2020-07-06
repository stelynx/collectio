import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../util/constant/country.dart';
import '../util/function/enum_helper.dart';

class UserProfile {
  String email;
  String firstName;
  String lastName;
  Country country;
  String profileImg;
  String userUid;
  String username;
  int premiumCollectionsAvailable;

  String get id => username;

  UserProfile({
    @required this.email,
    this.firstName,
    this.lastName,
    this.country,
    this.profileImg,
    @required this.userUid,
    @required this.username,
    this.premiumCollectionsAvailable = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        country: enumFromString<Country>(json['country'], Country.values),
        profileImg: json['profileImg'] != '' ? json['profileImg'] : null,
        userUid: json['userUid'],
        username: json['username'],
        premiumCollectionsAvailable: json['premiumCollectionsAvailable'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'country': country != null ? describeEnum(country) : '',
        'profileImg': profileImg ?? '',
        'userUid': userUid,
        'username': username,
        'premiumCollectionsAvailable': premiumCollectionsAvailable,
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
