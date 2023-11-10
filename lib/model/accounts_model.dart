import 'package:cloud_firestore/cloud_firestore.dart';

class AccountsModel {
  String? gender;
  int? weekdaySitterRate;
  String? firstName;
  Timestamp? dateOfBirth;
  double? ratingAvg;
  int? ratingNum;
  String? profilePicURL;
  String? lastName;

  AccountsModel(
      {this.gender,
      this.weekdaySitterRate,
      this.firstName,
      this.dateOfBirth,
      this.ratingAvg,
      this.ratingNum,
      this.profilePicURL,
      this.lastName});

  AccountsModel.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    weekdaySitterRate = json['weekdaySitterRate'];
    firstName = json['firstName'];
    dateOfBirth = json['dateOfBirth'];
    ratingAvg = json['ratingAvg'];
    ratingNum = json['ratingNum'];
    profilePicURL = json['profilePicURL'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['weekdaySitterRate'] = weekdaySitterRate;
    data['firstName'] = firstName;
    data['dateOfBirth'] = dateOfBirth;
    data['ratingAvg'] = ratingAvg;
    data['ratingNum'] = ratingNum;
    data['profilePicURL'] = profilePicURL;
    data['lastName'] = lastName;
    return data;
  }
}
