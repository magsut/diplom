import 'dart:convert';

import 'package:flutter_app/data/UserData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String _sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String _sharedPreferenceUserAuthoriseInKey = "ISAUTHORISE";
  static String _sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String _sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static String _sharedPreferenceNoticeKey = "NOTICEKEY";
  static String _sharedPreferenceUserDataKey = "USERDATAKEY";
  static String _sharedPreferenceUserPhotoKey = "USERPHOTOKEY";


  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveNoticeSettingsSharedPreference(bool NoticeSettings) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_sharedPreferenceNoticeKey, NoticeSettings);
  }

  static Future<bool> saveUserAuthorisedInSharedPreference(bool isUserAuthorise) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(_sharedPreferenceUserAuthoriseInKey, isUserAuthorise);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserDataSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    UserData userData = UserData();
    String json = jsonEncode(userData.toJson());
    print(json);
    return await preferences.setString(_sharedPreferenceUserDataKey, json);
  }

  static Future<bool> saveUserPhotoSharedPreference(String userPhoto) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(_sharedPreferenceUserPhotoKey, userPhoto);
  }

  static Future<bool?> getUserLoggedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_sharedPreferenceUserLoggedInKey);
  }

  static Future<bool?> getUserAuthorisedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_sharedPreferenceUserAuthoriseInKey);
  }

  static Future<String?> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_sharedPreferenceUserEmailKey);
  }

  static Future<bool?> getNoticeSettingsSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_sharedPreferenceNoticeKey);
  }

  static Future<String?> getUserDataSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_sharedPreferenceUserDataKey);
  }

  static Future<String?> getUserPhotoSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_sharedPreferenceUserPhotoKey);
  }
}