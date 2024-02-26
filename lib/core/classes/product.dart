import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/httpRequests/http.dart';
import 'package:flutter/material.dart';

class Product {
  String? barcode;
  String? title;
  String? description;

  Categories? category;

  List<SizeList>? sizeLists;

  String? vatRate;
  String? cargoCompanyId;

  List<NetworkImage>? images;

  String? adderUserid;
  String? adderUserMail;
  String? adderUserName;

  Product({
    this.barcode,
    this.title,
    this.category,
    this.sizeLists,
    this.description,
    this.cargoCompanyId,
    this.adderUserid,
    this.adderUserMail,
    this.adderUserName,
    this.images,
    this.vatRate,
  });

  static List<Product> products = [];
  static Product? selectedProduct;

  /* 
  ⁡⁢⁢⁡⁢⁣⁢upload Product On Database
  
  TODO : Product init 1 time on loading⁡⁡
   */
  static Future<bool> uploadProductToDatabase(
      Product newProduct, List<File> productImages) async {
    Map responses = {};
    Map<String, dynamic> data = {
      'createProduct': 'ok',
      'shop_token': Shop.selectedShop!.shop_token,
      'product': {
        'title': newProduct.title,
        'barcode': newProduct.barcode,
        'description': newProduct.description,
        'vatRate': newProduct.vatRate,
        'sizeLists': SizeList.createMapOfSizelist(newProduct.sizeLists!),
        'categories': newProduct.category != null
            ? Categories.mapOfCategories(newProduct.category!)
            : {}
      },
      'user': User.productAdder()
    };

    if (productImages.isNotEmpty) {
      responses = await HTTP_Requests.postImagesWithDio(productImages, data);
    } else {
      responses = await HTTP_Requests.sendPostRequest(data);
    }

    if (responses['id'] == 0) {
      _createProductObject(jsonDecode(responses['product']));
      return true;
    } else {
      return false;
    }
  }

  static void clearShopProduct() => products = [];

  static List<Product> lastFiveProducts() {
    // products listesinin uzunluğunu kontrol ederek son beş ürünü alalım

    int startIndex = products.length > 3 ? 3 : products.length;

    return products.sublist(0, startIndex);
  }

  static List<Product> getRandomObjects(int count) {
    if (count >= products.length) {
      // Liste eleman sayısından fazla sayıda isteniyorsa, listenin kendisini döndür
      return products;
    }

    // Rastgele sayı üretmek için Random sınıfını kullan
    Random random = Random();

    // Liste üzerinde işlem yapmadan önce bir kopyasını oluştur
    List<Product> copyList = List.from(products);

    // Seçilecek elemanları tutacak bir liste oluştur
    List<Product> selectedObjects = [];

    // Belirtilen sayıda rastgele eleman seç
    for (int i = 0; i < count; i++) {
      // Rastgele bir indis seç
      int randomIndex = random.nextInt(copyList.length);

      // Seçilen elemanı listeye ekle
      selectedObjects.add(copyList[randomIndex]);

      // Seçilen elemanı kopya listeden kaldır
      copyList.removeAt(randomIndex);
    }

    return selectedObjects;
  }

  static int productCategoryCount(Categories searchedCategories) {
    int count = 0;
    if (searchedCategories.subCategoriesId != -1) {
      count = products
          .where((element) => element.category == searchedCategories)
          .length;
    } else {
      count = products
          .where((element) =>
              element.category == _mainCategory(searchedCategories))
          .length;
    }
    return count;
  }

  static Categories _mainCategory(Categories searchedCategories) {
    return Categories._menutypeList.firstWhere(
        (element) => element.menuTypeId == searchedCategories.subCategoriesId);
  }

  static void initilizeProductsFromDatabase(List products) {
    /* 
      ⁡⁣⁣⁢first initiliaze product from database⁡
     */
    for (var element in products) {
      _createProductObject(element);
    }
    _reverseList();
  }

  static void _reverseList() {
    products = products.reversed.toList();
  }

  static void setSelectedProduct(Product product) {
    selectedProduct = product;
  }

  static void _createProductObject(Map response) {
    products.add(productObject(response));
  }

  static Product productObject(Map response) => Product(
        barcode: response['barcode'],
        title: response['title'],
        category: response['categories'] != null
            ? _initializeCategoryFromDatabase(response['categories'])
            : null,
        sizeLists: _sizeListsOfProducts(response['sizeLists']),
        description: response['description'],
        cargoCompanyId: '',
        images: _listOfProductNetworkImages(response['images']),
        vatRate: response['vatRate'],
        adderUserid: response['user']['id'],
        adderUserName: response['user']['userName'],
        adderUserMail: response['user']['userMail'],
      );

  static Product? findProductByBarcode(String scanedBarcode) {
    int findedProductByBarcode =
        products.indexWhere((element) => element.barcode == scanedBarcode);
    if (findedProductByBarcode != -1) {
      return products[findedProductByBarcode];
    }
    return null;
  }

  static Categories? _initializeCategoryFromDatabase(Map response) {
    return Categories(
        name: response['name'],
        menuTypeId: int.parse(response['menuTypeId']),
        subCategoriesId: int.parse(response['subCategoriesId']));
  }

  static List<SizeList> _sizeListsOfProducts(List sizelist) {
    List<SizeList> sizes = [];
    for (var element in sizelist) {
      sizes.add(
        SizeList(
          id: int.parse(element['id']),
          nameOfSize: element['nameOfSize'],
          quantity: int.parse(element['quantity']),
          stockCode: element['stockCode'],
          dimensionalWeight: element['dimensionalWeight'],
          listPrice: double.parse(element['listPrice']),
          alertLowStock: int.parse(element['alertLowStock']),
          listPriceCurrency: element['listPriceCurrency'],
          salePrice: double.parse(element['salePrice']),
          salePriceCurency: element['salePriceCurency'],
        ),
      );
    }
    return sizes;
  }

  static List<NetworkImage> _listOfProductNetworkImages(List networkUrls) {
    List<NetworkImage> _networkImages = [];
    for (var element in networkUrls) {
      _networkImages.add(NetworkImage(element));
    }
    return _networkImages;
  }

  static List<Product> lowStockProducts() {
    List<Product> _lowProducts = [];
    for (var element in products) {
      if (element.sizeLists!.length > 1) {
        for (var sizes in element.sizeLists!) {
          if (sizes.alertLowStock! >= sizes.quantity! && sizes.quantity! != 0) {
            _lowProducts.add(element);
            break;
          }
        }
      } else {
        if (element.sizeLists!.first.alertLowStock! >=
                element.sizeLists!.first.quantity! &&
            element.sizeLists!.first.quantity! != 0) {
          _lowProducts.add(element);
        }
      }
    }
    return _lowProducts;
  }

  static List<Product> doneStockProducts() {
    List<Product> _lowProducts = [];
    for (var element in products) {
      if (element.sizeLists!.length > 1) {
        for (var sizes in element.sizeLists!) {
          if (0 == sizes.quantity!) {
            _lowProducts.add(element);
            break;
          }
        }
      } else {
        if (0 == element.sizeLists!.first.quantity!) {
          _lowProducts.add(element);
        }
      }
    }
    return _lowProducts;
  }

  static bool isThereAnyWarning() =>
      !(lowStockProducts().isEmpty && doneStockProducts().isEmpty);
}

class SizeList {
  final int? id;
  final String? nameOfSize;
  final String stockCode;
  final int? quantity;
  final int? alertLowStock;
  final String? dimensionalWeight;
  final double listPrice;
  final String listPriceCurrency;
  final double salePrice;
  final String salePriceCurency;

  SizeList({
    required this.id,
    required this.nameOfSize,
    required this.quantity,
    required this.stockCode,
    required this.dimensionalWeight,
    required this.listPrice,
    required this.alertLowStock,
    required this.listPriceCurrency,
    required this.salePrice,
    required this.salePriceCurency,
  });
  static SizeList createNewSizeList(
      {String? name,
      int? stock,
      String? stockCodes,
      String? dimensionalWeights,
      required double listPrices,
      required int alertLowStock,
      required String listPriceCurrencys,
      required double salePrices,
      required String salePriceCurencys}) {
    /* 
    ⁡⁢⁣⁡⁢⁣⁣map for creation of new product for Sizelist ⁡
     */

    return SizeList(
        id: Random().nextInt(99999999),
        nameOfSize: name ??
            '${Shop.selectedShop!.shop_name} - Ürün ${Random().nextInt(20)}',
        quantity: stock ?? -1,
        alertLowStock: alertLowStock,
        stockCode: stockCodes ??
            '${Shop.selectedShop!.shop_id} - ${Random().nextInt(2000)}',
        dimensionalWeight: dimensionalWeights ?? '',
        listPrice: listPrices,
        listPriceCurrency: listPriceCurrencys,
        salePrice: salePrices,
        salePriceCurency: salePriceCurencys);
  }

  static SizeList initSizelist(Map response) => SizeList(
      id: int.parse(response['id']),
      nameOfSize: response['nameOfSize'],
      quantity: int.parse(response['quantity']),
      stockCode: response['stockCode'],
      dimensionalWeight: response['dimensionalWeight'],
      listPrice: double.parse(response['listPrice']),
      alertLowStock: int.parse(response['alertLowStock']),
      listPriceCurrency: response['listPriceCurrency'],
      salePrice: double.parse(response['salePrice']),
      salePriceCurency: response['salePriceCurency']);

  static List<Map> createMapOfSizelist(List<SizeList> sizeLists) {
    /* 
    ⁡⁢⁣⁢map for creation of database for Sizelist⁡
     */
    List<Map> returns = [];
    for (var element in sizeLists) {
      returns.add({
        'id': element.id,
        'nameOfSize': element.nameOfSize,
        'quantity': element.quantity,
        'alertLowStock': element.alertLowStock,
        'stockCode': element.stockCode,
        'dimensionalWeight': element.dimensionalWeight,
        'listPrice': element.listPrice,
        'listPriceCurrency': element.listPriceCurrency,
        'salePrice': element.salePrice,
        'salePriceCurency': element.salePriceCurency,
      });
    }
    return returns;
  }
}

class ParaBirimi {
  final String ad, kod;
  final int direction;
  final double? buy, sell;

  ParaBirimi({
    required this.ad,
    required this.kod,
    this.buy,
    this.direction = 0,
    this.sell,
  });
  static List<ParaBirimi> paraBirimleri = [
    /* ParaBirimi(ad: "Türk Lirası", kod: "TRY"),
    ParaBirimi(ad: "ABD Doları", kod: "USD"),
    ParaBirimi(ad: "Euro", kod: "EUR"),
    ParaBirimi(ad: "Japon Yeni", kod: "JPY"),
    ParaBirimi(ad: "İngiliz Sterlini", kod: "GBP"),
    ParaBirimi(ad: "İsviçre Frangı", kod: "CHF"),
    ParaBirimi(ad: "Kanada Doları", kod: "CAD"),
    ParaBirimi(ad: "Avustralya Doları", kod: "AUD"),
    ParaBirimi(ad: "Çin Yuanı", kod: "CNY"),
    ParaBirimi(ad: "İsveç Kronu", kod: "SEK"),
    ParaBirimi(ad: "Yeni Zelanda Doları", kod: "NZD"),
    ParaBirimi(ad: "Güney Kore Wonu", kod: "KRW"),
    ParaBirimi(ad: "Singapur Doları", kod: "SGD"),
    ParaBirimi(ad: "Norveç Kronu", kod: "NOK"),
    ParaBirimi(ad: "Meksika Pezosu", kod: "MXN"),
    ParaBirimi(ad: "Güney Afrika Randı", kod: "ZAR"),
    ParaBirimi(ad: "Rus Rublesi", kod: "RUB"),
    ParaBirimi(ad: "Hindistan Rupisi", kod: "INR"),
    ParaBirimi(ad: "Brezilya Reali", kod: "BRL"),
    ParaBirimi(ad: "Endonezya Rupiahı", kod: "IDR"),
    ParaBirimi(ad: "Suudi Riyali", kod: "SAR"),
    ParaBirimi(ad: "Malezya Ringiti", kod: "MYR"),
    ParaBirimi(ad: "Hong Kong Doları", kod: "HKD"),
    ParaBirimi(ad: "Polonya Zlotisi", kod: "PLN"),
    ParaBirimi(ad: "Çek Korunası", kod: "CZK"),
    ParaBirimi(ad: "Macar Forinti", kod: "HUF"),
    ParaBirimi(ad: "Şili Pesosu", kod: "CLP"),
    ParaBirimi(ad: "İsrail Şekeli", kod: "ILS"),
    ParaBirimi(ad: "Katar Riyali", kod: "QAR"),
    ParaBirimi(ad: "Arjantin Pesosu", kod: "ARS"), */
  ];
  static Future<bool> fetchCurrenciesFromDatabase() async {
    List<String> getData = [
      'currency=ok',
      'user_token=${User.userProfile!.token}'
    ];
    List data = await HTTP_Requests.getHttp(getData);
    if (data.isNotEmpty) {
      paraBirimleri = [];
      for (var element in data) {
        paraBirimleri.add(_paraBirimi(element));
      }
      return true;
    } else {
      return false;
    }
  }

  static ParaBirimi _paraBirimi(Map response) => ParaBirimi(
        ad: response['currency_meta_name'],
        kod: response['currency_meta_fetchCode'],
        buy: double.parse(response['currency_meta_buy']),
        sell: double.parse(response['currency_meta_sell']),
        direction: int.parse(response['currency_meta_buy_direction']),
      );
}

class Categories {
  final String name;
  final int menuTypeId;
  final int subCategoriesId;
  final IconData? icon;
  Categories({
    this.icon,
    required this.name,
    required this.menuTypeId,
    this.subCategoriesId = -1,
  });

  static List<Categories> _menutypeList = [];

  static void clearCategories() => _menutypeList = [];

  static Future<bool> createNewCategories(Categories selectedMenutype) async {
    String token = Shop.selectedShop!.shop_token!;

    Map<String, dynamic> data = {
      'addNewCategorywithToken': 'ok',
      'shop_token': token,
      'categories': jsonEncode(mapOfCategories(selectedMenutype))
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      _menutypeList.add(selectedMenutype);
      return true;
    } else {
      return false;
    }
  }

  static Map mapOfCategories(Categories selectedMenutype) {
    return {
      'name': selectedMenutype.name,
      'menuTypeId': selectedMenutype.menuTypeId,
      'subCategoriesId': selectedMenutype.subCategoriesId
    };
  }

  static void initShopCategories(List<dynamic> table) {
    for (var element in table) {
      _menutypeList.add(
        Categories(
            name: element['name'],
            menuTypeId: element['menuTypeId'],
            subCategoriesId: element['subCategoriesId']),
      );
    }
  }

  static bool menuTypeIsEmpty() => _menutypeList.isEmpty;

  static void _deleteCategoryFromList(Categories deletedCategory) {
    int delededCategoryIndex =
        _menutypeList.indexWhere((element) => element == deletedCategory);
    if (delededCategoryIndex != -1) {
      _menutypeList.removeAt(delededCategoryIndex);
    }
  }

  static Future<bool> deleteCategories(Categories deletedCategory) async {
    String token = Shop.selectedShop!.shop_token!;

    Map<String, dynamic> data = {
      'deleteCategorywithToken': 'ok',
      'shop_token': token,
      'categories': jsonEncode({
        'name': "${deletedCategory.name}",
        'menuTypeId': deletedCategory.menuTypeId,
        'subCategoriesId': deletedCategory.subCategoriesId,
      })
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);
    if (returns['id'] == 0) {
      _deleteCategoryFromList(deletedCategory);
      return true;
    } else {
      return false;
    }
  }

  static List<Categories> returnMainCategoriess() {
    return _menutypeList
        .where((element) => element.subCategoriesId == -1)
        .toList();
  }

  static bool isThereSubMenu(int subCategoriesId) {
    int indexOfExistingShopTableOrder = _menutypeList
        .indexWhere((element) => element.subCategoriesId == subCategoriesId);
    if (indexOfExistingShopTableOrder != -1) {
      return true;
    } else {
      return false;
    }
  }

  static List<Categories> returnSubCategoriess(int subCategoriesId) {
    return _menutypeList
        .where((element) => element.subCategoriesId == subCategoriesId)
        .toList();
  }
}

/* 
enum FoodStockStatus { full, empty, less }

class FoodProduct {
  String name;
  String? foodId;
  String? subName;
  String? description;
  MenuType menuType;
  bool isProductAvailable;
  String kcal;
  AdditionCount? count;
  double rate;
  List<NetworkImage> networkImages;
  List<SizeList>? size;
  SizeList? selectedSize;

  FoodProduct({
    required this.name,
    required this.menuType,
    this.description,
    this.foodId,
    this.isProductAvailable = false,
    this.rate = 0.0,
    this.networkImages = const [],
    this.kcal = '0',
    this.count,
    this.size,
    this.subName,
    this.selectedSize,
  });
  static FoodProduct? selectedProduct;
  static List<FoodProduct> shopProductList = [];

  static Future<bool> fetchShopProducts() async {
    String shop_token = Shop.selectedShop!.shop_token ?? '';

    Map<String, dynamic> data = {
      'fetchProductList': 'ok',
      'shop_token': shop_token,
    };
    Map returns = await HTTP_Requests.sendPostRequest(data);

    if (returns['id'] == 0) {
      initShopProductList(returns['products']);
      return true;
    } else {
      return false;
    }
  }

  static void setFetchedShopProducts() {}

  static FoodStockStatus stockStatusCheck(FoodProduct product) {
    int stock = 0;
    for (var element in product.size!) {
      stock += element.stock;
    }
    if (stock > 20) {
      return FoodStockStatus.full;
    } else if (stock < 20 && stock != 0) {
      return FoodStockStatus.less;
    } else {
      return FoodStockStatus.empty;
    }
  }

  static void addNewFoodProduct(FoodProduct foodProduct) =>
      shopProductList.add(foodProduct);

  static void initShopProductList(List fetchedProducts) {
    for (var element in fetchedProducts) {
      shopProductList.add(
        FoodProduct(
          name: element['name'],
          menuType: MenuType(
            name: element['menuType']['name'],
            menuTypeId: int.parse(
              element['menuType']['menuTypeId'],
            ),
            subMenuTypeId: int.parse(
              element['menuType']['subMenuTypeId'],
            ),
          ),
          description: element['description'],
          foodId: element['id'],
          isProductAvailable: bool.parse(element['isProductAvailable']),
          networkImages: _createListOfPhoto(element['images']),
          kcal: element['kcal'],
          size: _createSizeLists(element['size']),
          subName: element['subName'],
        ),
      );
    }
  }

  static List<NetworkImage> _createListOfPhoto(List images) {
    List<NetworkImage> returns = [];
    for (var element in images) {
      returns.add(NetworkImage(element));
    }
    return returns;
  }

  static List<SizeList> _createSizeLists(List sizeList) {
    List<SizeList> returns = [];
    for (var element in sizeList) {
      returns.add(
        SizeList(
          price: double.parse(element['price']),
          size: element['size'],
          diameter: element['diameter'],
          stock: int.parse(
            element['stock'],
          ),
        ),
      );
    }
    return returns;
  }

  static void setSelectedProduct(FoodProduct foodProduct) {
    selectedProduct = foodProduct;
  }

  static Map<String, dynamic> createPostMap(FoodProduct createdFoodProduct) {
    List<Map> size = [];
    for (var element in createdFoodProduct.size!) {
      size.add({
        'size': element.size,
        'diameter': element.diameter,
        'price': element.price,
        'stock': element.stock,
      });
    }

    Map<String, dynamic> data = {
      'createNewProduct': 'ok',
      'shop_token': Shop.selectedShop!.shop_token,
      'product_meta': {
        'name': createdFoodProduct.name,
        'id': createdFoodProduct.foodId ?? (Random().nextInt(89999) + 10000),
        'subName': createdFoodProduct.subName ?? '',
        'description': createdFoodProduct.description ?? '',
        'isProductAvailable': createdFoodProduct.isProductAvailable,
        'kcal': createdFoodProduct.kcal,
        'menuType': {
          'name': createdFoodProduct.menuType.name,
          'menuTypeId': createdFoodProduct.menuType.menuTypeId,
          'subMenuTypeId': createdFoodProduct.menuType.subMenuTypeId,
        },
        'size': size
      },
    };
    return data;
  }
}

class AdditionCount {
  final int additionCount;
  final double additionPrice;

  AdditionCount({
    required this.additionCount,
    required this.additionPrice,
  });
}

class SizeList {
  final int? id;
  final String? size;
  final String? diameter;
  final double price;
  final int stock;
  SizeList({
    this.id,
    this.size,
    this.diameter,
    required this.price,
    this.stock = 99999,
  });
}

class Ingrediant {
  final IconData? icon;
  final String ingradiantName;
  Ingrediant({this.icon, required this.ingradiantName});
}
 */