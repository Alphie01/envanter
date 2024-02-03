import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';

class Siparis {
  final Product product;
  final SizeList selectedSizelist;
  final int count;
  final String saleCurrency;
  final double salePrice, discount;
  final User? whoCreateSiparis;

  Siparis({
    required this.product,
    required this.selectedSizelist,
    this.count = 0,
    required this.salePrice,
    required this.saleCurrency,
    this.discount = 0,
    required this.whoCreateSiparis,
  });

  static List<Siparis> lastSiparis = [];

  static void initilizeOrdersFromDatabase(List orders) {
    for (var element in orders) {
      lastSiparis.add(_siparis(element));
    }
    _reverseList();
  }

  static Siparis _siparis(Map response) {
    return Siparis(
      product: Product.productObject(response['product']),
      selectedSizelist: SizeList.initSizelist(response['selectedSizelist']),
      salePrice: double.parse('${response['sale_price']}'),
      whoCreateSiparis: Shop.userFindById(response['whoCreateSiparis']['id']),
      count: response['count'],
      discount: double.parse('${response['discount']}'),
      saleCurrency: response['sale_currency'],
    );
  }

  static void clearSiparisList() => lastSiparis = [];

  static void _reverseList() {
    lastSiparis = lastSiparis.reversed.toList();
  }
}
