import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/httpRequests/http.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:flutter/material.dart';

class User {
  String? userId;
  String userKAdi;
  String? userPassword;
  String userName;
  String userMail;

  String? userPermissionLevel;
  String? userStartDate;
  String? userBirthdate;
  String? userTC;
  String? userGsm;
  String? userAdres;
  String? userIl;
  String? userIlce;

  UserStatus userStatus;

  NetworkImage userProfilePhoto;
  NetworkImage userPThumbNail;

  List<String>? platformId;

  User({
    this.userId,
    required this.userKAdi,
    this.userPassword,
    required this.userMail,
    this.userPermissionLevel,
    this.userStartDate,
    this.platformId,
    this.userAdres,
    this.userStatus = UserStatus.notApproved,
    this.userIl,
    this.userIlce,
    this.userGsm,
    required this.userName,
    this.userBirthdate,
    this.userPThumbNail = const NetworkImage(
        'https://st3.depositphotos.com/8361896/34679/v/600/depositphotos_346793456-stock-video-beautiful-abstract-holographic-gradient-rainbow.jpg'),
    this.userProfilePhoto =
        const NetworkImage('https://robolink.com.tr/assets/user-avatar.png'),
  });

  static User? userProfile;
  static bool biometrics = true;

  static Future<Map<String, dynamic>?> register_account(
      Map<String, dynamic> data) async {
    Map returns = await HTTP_Requests.sendPostRequest(data);
    print(returns);
    if (returns['id'] == 0) {
      return returns['result'];
    } else {
      return {'error_message': returns['error_message']};
    }
  }

  static Future<bool> chekMailKey(Map<String, dynamic> data) async {
    Map returns = await HTTP_Requests.sendPostRequest(data);
    if (returns['id'] == 0) {
      SharedPref.addStringToSF(
          userToken, returns['kullanici']['kullanici_secretToken']);
      String path = '';
      if (returns['kullanici']['kullanici_resim'] != null) {
        path = returns['kullanici']['kullanici_resim'];
      } else {
        path = 'https://robolink.com.tr/assets/user-avatar.png';
      }
      userProfile = _createUserParamater(returns['kullanici'], path);
      biometrics = false;
      return true;
    } else {
      return false;
    }
  }

  static String userParamaterForGET() =>
      'kullanici_id=' + User.userProfile!.userId!;

  static Future<bool> fetchUserbyToken(token) async {
    Map<String, dynamic> data = {'fetchUserByToken': 'ok', 'userToken': token};
    Map returns = await HTTP_Requests.sendPostRequest(data);
    /* List a = await  */

    if (returns['id'] == 0) {
      SharedPref.addStringToSF(
          userToken, returns['kullanici']['kullanici_secretToken']);

      String path = '';
      if (returns['kullanici']['kullanici_resim'] != null) {
        path = returns['kullanici']['kullanici_resim'];
      } else {
        path = 'https://robolink.com.tr/assets/user-avatar.png';
      }

      /* List<dynamic> _platforms = returns['kullanici']['platforms']; */
      List<String> _canPlatformList = [];

      /* for (var element in _platforms) {
        _canPlatformList.add(element['kullanici_platformTokens_platformId']);
      } */

      userProfile = _createUserParamater(returns['kullanici'], path);

      //setting up Shops
      Shop.setAttendedShops(returns['shop']);
      return true;
    } else {
      return false;
    }
  }

  static User _createUserParamater(Map returns, String path) {
    List<String> _canPlatformList = [];
    return User(
        userId: returns['kullanici_id'],
        userKAdi: '${returns['kullanici_ad']}',
        userPassword: '${returns['kullanici_password']}',
        userName: '${returns['kullanici_adsoyad']}',
        userMail: '${returns['kullanici_mail']}',
        userStatus: userStatusChecker(returns['kullanici_durum']),
        userProfilePhoto: NetworkImage(path),
        userPermissionLevel: returns['kullanici_yetki'],
        userStartDate: '${returns['kullanici_zaman']}',
        platformId: _canPlatformList);
  }

  static UserStatus userStatusChecker(String status) {
    switch (status) {
      case '1':
        return UserStatus.approved;
      case '0':
        return UserStatus.notApproved;
      case '-1':
        return UserStatus.banned;
      default:
        return UserStatus.approved;
    }
  }

  static Future<Map> fetchUserbyMail(String mail, String password) async {
    Map<String, dynamic> data = {
      'fetchUserByMail': 'ok',
      'kullanici_mail': mail,
      'kullanici_password': password
    };

    Map returns = await HTTP_Requests.sendPostRequest(data);

    /* List a = await  */

    if (returns['id'] == 0) {
      SharedPref.addStringToSF(
          userToken, returns['kullanici']['kullanici_secretToken']);

      String path = '';
      if (returns['kullanici']['kullanici_resim'] != null) {
        path = returns['kullanici']['kullanici_resim'];
      } else {
        path = 'https://robolink.com.tr/assets/user-avatar.png';
      }

      List<String> _canPlatformList = [];

      userProfile = _createUserParamater(returns['kullanici'], path);
      biometrics = false;

      return {'id': 0, 'error_message': 'Giriş Başarılı!'};
    } else {
      return returns;
    }
  }

  static void logout() => userProfile = null;

  static List<User> initUserByList(List users) {
    List<User> _users = [];
    for (var element in users) {
      _users.add(
        User(
          userKAdi: element['kullanici_ad'],
          userMail: element['kullanici_mail'],
          userName: element['kullanici_adsoyad'],
        ),
      );
    }
    return _users;
  }

  static Map productAdder() {
    Map user = {
      'id': userProfile!.userId,
      'userMail': userProfile!.userMail,
      'userName': userProfile!.userName
    };
    return user;
  }
}

enum UserStatus { approved, notApproved, banned }
