import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/user.dart';

class Siparis {
  final Product product;
  final int count;
  final double salePrice, discount;
  final User whoCreateSiparis;

  Siparis({
    required this.product,
    this.count = 0,
    required this.salePrice,
    this.discount = 0,
    required this.whoCreateSiparis,
  });
}
