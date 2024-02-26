import 'package:envanterimservetim/core/classes/company.dart';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';

class Siparis {
  final List<OrderedProduct> orders;
  final Company sendedcompany, ownerCompany;

  Siparis({
    required this.orders,
    required this.sendedcompany,
    required this.ownerCompany,
  });
}

class OrderedProduct {
  final Product product;
  final SizeList selectedSizelist;
  final int count;
  final String saleCurrency;
  final double salePrice, discount;
  final User? whoCreateOrderedProduct;

  OrderedProduct({
    required this.product,
    required this.selectedSizelist,
    this.count = 0,
    required this.salePrice,
    required this.saleCurrency,
    this.discount = 0,
    required this.whoCreateOrderedProduct,
  });

  static List<OrderedProduct> lastOrderedProduct = [];

  static void initilizeOrdersFromDatabase(List orders) {
    for (var element in orders) {
      lastOrderedProduct.add(_OrderedProduct(element));
    }
    _reverseList();
  }

  static OrderedProduct _OrderedProduct(Map response) {
    return OrderedProduct(
      product: Product.productObject(response['product']),
      selectedSizelist: SizeList.initSizelist(response['selectedSizelist']),
      salePrice: double.parse('${response['sale_price']}'),
      whoCreateOrderedProduct:
          Shop.userFindById(response['whoCreateOrderedProduct']['id']),
      count: response['count'],
      discount: double.parse('${response['discount']}'),
      saleCurrency: response['sale_currency'],
    );
  }

  static void clearOrderedProductList() => lastOrderedProduct = [];

  static void _reverseList() {
    lastOrderedProduct = lastOrderedProduct.reversed.toList();
  }
}
