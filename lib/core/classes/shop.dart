// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:envanterimservetim/core/classes/company.dart';
import 'package:envanterimservetim/core/classes/siparis.dart';
import 'package:envanterimservetim/core/classes/notifications.dart';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/httpRequests/http.dart';
import 'package:flutter/material.dart';

class Shop {
  final int shop_id;
  final String shop_name;
  final NetworkImage shop_image;
  final int shopType;
  final String? shop_desc;
  final String? shop_token;
  final int? userPermissionLevel;
  final int? shop_owner_Id;
  List<User> shopWorkers, waitingApprove;
  final int shopPrivacy;
  final ShopPermissions shopPermissions;
  Company? companyInfo;

  Shop({
    required this.shop_id,
    required this.shop_name,
    required this.shop_image,
    required this.shopPermissions,
    required this.shopType,
    this.userPermissionLevel,
    this.companyInfo,
    this.shopPrivacy = 0,
    this.shop_token,
    this.shop_desc,
    this.shop_owner_Id,
    this.shopWorkers = const [],
    this.waitingApprove = const [],
  });

  static List<Shop> attendedShops = [];
  static List<Shop> invitedShops = [];
  static Shop? selectedShop = null;
/* 
  static List<ShopTable> listofShopTable = [];
 */
  static bool isSelectedShop() {
    return selectedShop != null ? true : false;
  }

  static ShopPermissions _shopPermissionsInitilazer(
      Map<String, dynamic> initilazedArray) {
    ShopPermissions returns = ShopPermissions(
      shop_can_add_teammates: initilazedArray['user_control']
          ['shop_can_add_teammates'],
      shop_can_categorise_teammates: initilazedArray['user_control']
          ['shop_can_add_teammates'],
      shop_can_sell_products: initilazedArray['payout']
          ['shop_can_sell_products'],
      shop_can_bill: initilazedArray['payout']['shop_can_bill'],
      shop_can_categorise: initilazedArray['inventory_upgrade']
          ['shop_can_categorise'],
      shop_can_initilize_place: initilazedArray['inventory_upgrade']
          ['shop_can_initilize_place'],
      shop_can_initilize_low_stok: initilazedArray['inventory_upgrade']
          ['shop_can_initilize_low_stok'],
      shop_can_see_product_history: initilazedArray['inventory_upgrade']
          ['shop_can_see_product_history'],
      shop_can_init_reminder: initilazedArray['inventory_upgrade']
          ['shop_can_init_reminder'],
      shop_can_see_analytics: initilazedArray['analytics']
          ['shop_can_see_analytics'],
      shop_show_ads: initilazedArray['shop_show_ads'],
      shop_product_limit: initilazedArray['inventory_upgrade']
          ['shop_inventory_product_limit'],
      shop_can_decrease_stock: initilazedArray['inventory_upgrade']
          ['shop_can_decrease_stock'],
    );

    return returns;
  }

  static Future<bool> shop_init() async {
    String token = selectedShop!.shop_token!;

    Map<String, dynamic> data = {
      'initShopByToken': 'ok',
      'shop_token': token,
      'user_id': User.userProfile!.userId
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);
    print(returns);

    if (returns['id'] == 0) {
      clearShopDatas();
      ParaBirimi.fetchCurrenciesFromDatabase();
      Product.initilizeProductsFromDatabase(returns['products']);
      if (returns['workers'] != []) {
        _setShopWorkers(returns['workers']);
      }
      if (returns['waitingApprove'] != []) {
        _setwaitingWorkers(returns['waitingApprove']);
      }
      if (returns['categories'] != []) {
        Categories.initShopCategories(returns['categories']);
      }
      if (returns['notification'] != []) {
        Notifications.initilazeNotifications(returns['notification']);
      }
      if (returns['shop_sells'] != []) {
        /* Siparis.initilizeOrdersFromDatabase(returns['shop_sells']); */
      }

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> shop_changeUserPermission(
      {User? selectedUser, int permissionLevel = 0}) async {
    Map<String, dynamic> data = {
      'shop_changeUserPermission': 'ok',
      'shop_id': Shop.selectedShop!.shop_id,
      'changed_userId': selectedUser!.userId,
      'permissionLevel': permissionLevel
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    print(returns);
    if (returns['id'] == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> shop_answerInvitation(
      {bool answer = false, required int token}) async {
    Map<String, dynamic> data = {
      'answerInvitation': 'ok',
      'shop_id': token,
      'answeredUser_id': User.userProfile!.userId,
      'answer': answer ? 1 : -1
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> shop_leaveCompany(
      {bool answer = false, required int token}) async {
    Map<String, dynamic> data = {
      'leaveCompany': 'ok',
      'shop_id': token,
      'answeredUser_id': User.userProfile!.userId,
      'answer': -1
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Map> shop_sendInvitation({required User worker}) async {
    int token = selectedShop!.shop_id;

    Map<String, dynamic> data = {
      'sendInvitation': 'ok',
      'shop_id': token,
      'user_id': worker.userId,
      'answeredUser_id': User.userProfile!.userId,
      'answer': 2
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    print(returns);
    if (returns['id'] == 0) {
      return {'id': 0};
    } else {
      return returns;
    }
  }

  static Future<bool> shop_answerWaitingPeron(
      {required User worker, bool answer = false}) async {
    //TODO statistic INIT

    int token = selectedShop!.shop_id;

    Map<String, dynamic> data = {
      'answerWaitingWorker': 'ok',
      'shop_id': token,
      'user_id': User.userProfile!.userId,
      'answeredUser_id': worker.userId,
      'answer': answer ? 1 : -1
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      selectedShop!.waitingApprove.removeAt(_returnWorkerIndex(worker));
      if (answer) {
        selectedShop!.shopWorkers.add(worker);
      }
      return true;
    } else {
      return false;
    }
  }

  static User? userFindById(String id) {
    int indexOfExistingShopTableOrder =
        selectedShop!.shopWorkers.indexWhere((element) => element.userId == id);
    if (indexOfExistingShopTableOrder != -1) {
      return selectedShop!.shopWorkers[indexOfExistingShopTableOrder];
    } else {
      return null;
    }
  }

  static Future<User> getWorkerMoreInfo(User userInfo) async {
    User retUser = userInfo;
    Map<String, dynamic> data = {
      'getInfoWhoWorker': 'ok',
      'shop_token': Shop.selectedShop!.shop_id,
      'user_id': userInfo.userId,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      retUser.userGsm = returns['user_moreInfo']['kullanici_gsm'];
      retUser.userAdres = returns['user_moreInfo']['kullanici_adres'];
      retUser.userIl = returns['user_moreInfo']['kullanici_il'];
      retUser.userIlce = returns['user_moreInfo']['kullanici_ilce'];
    }
    return retUser;
  }

  static Future<List<User>?> getUserByMails(String userMail) async {
    Map<String, dynamic> data = {
      'getUserByMails': 'ok',
      'kullanici_mail': userMail,
      'shop_id': selectedShop!.shop_id
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      print(returns['UserByMails']);
      return User.initUserByList(returns['UserByMails']);
    }
    return null;
  }

  static void clearShopDatas() {
    Product.clearShopProduct();
    /* Siparis.clearSiparisList(); */
    Categories.clearCategories();
    Notifications.notificationClear();
  }

  static int _returnWorkerIndex(User user) {
    return selectedShop!.waitingApprove
        .indexWhere((element) => element == user);
  }

  static void _setShopWorkers(List userInfos) {
    List<User> users = [];
    for (var element in userInfos) {
      users.add(
        User(
          userKAdi: element['kullanici_ad'],
          userMail: element['kullanici_mail'],
          userName: element['kullanici_adsoyad'],
          userId: element['kullanici_id'],
          userPermissionLevel: element['shop_workers_permissonLevel'],
        ),
      );
    }
    Shop.selectedShop!.shopWorkers = users;
  }

  static void _setwaitingWorkers(List userInfos) {
    List<User> users = [];
    for (var element in userInfos) {
      users.add(
        User(
          userKAdi: element['kullanici_ad'],
          userMail: element['kullanici_mail'],
          userName: element['kullanici_adsoyad'],
          userId: element['kullanici_id'],
          userPermissionLevel: element['shop_workers_permissonLevel'],
        ),
      );
    }
    Shop.selectedShop!.waitingApprove = users;
  }

  static Future<bool> shop_buyPackage(
      List boughtPackages, String refreshDate) async {
    //TODO statistic INIT

    String token = selectedShop!.shop_token!;

    Map<String, dynamic> data = {
      'shop_buyPackage': 'ok',
      'shop_token': token,
      'packages': boughtPackages.join(','),
      'refreshDate': refreshDate,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      _setPermissionsAfterExtendPackage(boughtPackages);
      return true;
    } else {
      return false;
    }
  }

  static void _setPermissionsAfterExtendPackage(List boughtPackages) {
    for (var element in boughtPackages) {
      switch (element) {
        case 'user_control':
          Shop.selectedShop!.shopPermissions.shop_can_add_teammates = true;
          Shop.selectedShop!.shopPermissions.shop_can_categorise_teammates =
              true;
          break;

        case 'payout':
          Shop.selectedShop!.shopPermissions.shop_can_sell_products = true;
          Shop.selectedShop!.shopPermissions.shop_can_bill = true;

          break;
        case 'inventory_upgrade':
          Shop.selectedShop!.shopPermissions.shop_product_limit = -1;
          Shop.selectedShop!.shopPermissions.shop_can_categorise = true;
          Shop.selectedShop!.shopPermissions.shop_can_decrease_stock = true;
          Shop.selectedShop!.shopPermissions.shop_can_init_reminder = true;
          Shop.selectedShop!.shopPermissions.shop_can_initilize_place = true;
          Shop.selectedShop!.shopPermissions.shop_can_initilize_low_stok = true;
          Shop.selectedShop!.shopPermissions.shop_can_see_product_history =
              true;

          break;
        case 'analytics':
          Shop.selectedShop!.shopPermissions.shop_can_see_analytics = true;

          break;
      }
    }
  }

  static Future<String> getAccessCode() async {
    String accessCode = '';
    Map<String, dynamic> data = {
      'shop_getAccessCode': 'ok',
      'shop_token': Shop.selectedShop!.shop_token,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      accessCode = returns['shop_accessCode'];
    }
    return accessCode;
  }

  static Future<bool> createNewShop(Map<String, dynamic> creatingMap) async {
    String token = User.userProfile!.userId!;

    Map<String, dynamic> data = creatingMap;

    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      selectedShop = Shop(
        shop_id: int.parse(returns['shop']['shop_id']),
        shop_name: returns['shop']['shop_name'],
        shop_image: NetworkImage(returns['shop']['shop_image']),
        shopType: int.parse(returns['shop']['shop_type']),
        shop_desc: returns['shop']['shop_desc'],
        shopPrivacy: int.parse(returns['shop']['shop_privacy']),
        shop_token: returns['shop']['shop_token'],
        shopPermissions: _shopPermissionsInitilazer(
            jsonDecode(returns['shop']['shop_permissions'])),
        userPermissionLevel: 5,
      );

      return true;
    } else {
      return false;
    }
  }

  static Future<bool> shop_initByToken(String settedtoken) async {
    //TODO statistic INIT

    String token = settedtoken;

    Map<String, dynamic> data = {
      'initShopByToken': 'ok',
      'shop_token': token,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      //TODO INIT Products here
      if (selectedShop!.shopType == 0) {
      } else {
        /* FoodProduct.initShopProductList(returns['products']);
        MenuType.initShopMenuTypes(returns['categories']); */
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<Shop?> fetchExistedShop(String scanedToken) async {
    Map<String, dynamic> data = {
      'fetchExistedShop': 'ok',
      'shop_accessCode': scanedToken,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      return Shop(
        shop_id: int.parse(returns['shop']['shop_id']),
        shop_name: returns['shop']['shop_name'],
        shop_image: NetworkImage(returns['shop']['shop_image']),
        shopType: int.parse(returns['shop']['shop_type']),
        shop_desc: returns['shop']['shop_desc'],
        shopPrivacy: int.parse(returns['shop']['shop_privacy']),
        shopPermissions: _shopPermissionsInitilazer(
            jsonDecode(returns['shop']['shop_permissions'])),
      );
    } else {
      return null;
    }
  }

  static Future<Map?> joinExistedShop(String shop_id, String user_id) async {
    Map<String, dynamic> data = {
      'joinExistedShop': 'ok',
      'shop_id': shop_id,
      'user_id': user_id,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);
    if (returns['id'] == 0) {
      return returns;
    } else {
      return null;
    }
  }

  static void setInvitedShops(List<dynamic> shop) {
    invitedShops = [];
    for (var element in shop) {
      invitedShops.add(Shop(
        shop_id: int.parse(element['shop_id']),
        shop_name: element['shop_name'],
        shop_token: element['shop_token'],
        shop_image: NetworkImage(element['shop_image']),
        shopType: int.parse(element['shop_type']),
        userPermissionLevel: int.parse(element['shop_permissionLevel']),
        shopPermissions:
            _shopPermissionsInitilazer(jsonDecode(element['shop_permissions'])),
      ));
    }
  }

  static void setAttendedShops(List<dynamic> shop) {
    attendedShops = [];
    if (shop.length == 1) {
      selectedShop = Shop(
        shop_id: int.parse(shop[0]['shop_id']),
        shop_name: shop[0]['shop_name'],
        shop_token: shop[0]['shop_token'],
        shop_image: NetworkImage(shop[0]['shop_image']),
        shopType: int.parse(shop[0]['shop_type']),
        userPermissionLevel: int.parse(shop[0]['shop_permissionLevel']),
        shop_owner_Id: int.parse(shop[0]['shop_owner_Id']),
        shopPermissions:
            _shopPermissionsInitilazer(jsonDecode(shop[0]['shop_permissions'])),
      );

      shop_init();
    } else {
      for (var element in shop) {
        attendedShops.add(Shop(
          shop_id: int.parse(element['shop_id']),
          shop_name: element['shop_name'],
          shop_token: element['shop_token'],
          shop_image: NetworkImage(element['shop_image']),
          shopType: int.parse(element['shop_type']),
          shop_owner_Id: int.parse(element['shop_owner_Id']),
          userPermissionLevel: int.parse(element['shop_permissionLevel']),
          shopPermissions: _shopPermissionsInitilazer(
              jsonDecode(element['shop_permissions'])),
        ));
      }
    }
  }

  static void setSelectedShop(Shop setSelected) {
    selectedShop = setSelected;
    if (setSelected.shopType == 1) {
      /* fetchShopTableAddition(setSelected.shop_token); */
    }
  }

  static List<NetworkImage> _networkImageList(List images) {
    List<NetworkImage> _networkImages = [];
    for (var element in images) {
      _networkImages.add(NetworkImage(element));
    }
    return _networkImages;
  }

  static void logoutAllShops() {
    Shop.selectedShop = null;
    Shop.attendedShops = [];
  }

  static void logoutSelectedShops() {
    Shop.selectedShop = null;
  }

  static String permissionLevel(int permision) {
    String perm = 'Kullanıcı';

    switch (permision) {
      case 0:
        perm = 'Kullanıcı';
        break;
      case 1:
        perm = 'Yetkili Kullanıcı';
        break;
      case 5:
        perm = 'Admin';
        break;
      default:
        perm = 'Kullanıcı';
    }
    return perm;
  }
}

enum UserPermission { kullanici, yetkili, sahibi }

class ShopPermissions {
  bool shop_can_add_teammates;
  bool shop_can_categorise_teammates;
  bool shop_can_sell_products;
  bool shop_can_bill;
  bool shop_can_categorise;
  bool shop_can_initilize_place;
  bool shop_can_initilize_low_stok;
  bool shop_can_see_product_history;
  bool shop_can_see_analytics;
  bool shop_show_ads;
  bool shop_can_init_reminder;
  bool shop_can_decrease_stock;
  int shop_product_limit;

  ShopPermissions({
    this.shop_can_add_teammates = false,
    this.shop_can_categorise_teammates = false,
    this.shop_can_init_reminder = false,
    this.shop_can_decrease_stock = false,
    this.shop_can_sell_products = false,
    this.shop_can_bill = false,
    this.shop_can_categorise = false,
    this.shop_can_initilize_place = false,
    this.shop_can_initilize_low_stok = false,
    this.shop_can_see_product_history = false,
    this.shop_can_see_analytics = false,
    this.shop_show_ads = true,
    this.shop_product_limit = 50,
  });
}
