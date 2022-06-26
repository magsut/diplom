import 'dart:convert';

import 'DataModels.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserData.g.dart';

@JsonSerializable()
class UserData{
  static List<Car> userCars = [];
  static bool isLogged = false;
  static bool isAuthorise = false;
  static String token = '';
  static String userphoto = 'defUser.png';

  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'userCars': jsonEncode(userCars),
      'isLogged': isLogged,
      'isAuthorise': isAuthorise,
      'token': token,
      'userphoto' : userphoto
    };
  }

}