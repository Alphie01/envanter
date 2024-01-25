import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/homepage/homepage.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';

class LastOrders extends StatelessWidget {
  const LastOrders({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            margin: EdgeInsets.only(bottom: paddingHorizontal),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: AppTheme.textColor.withOpacity(.3)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [AppLargeText(text: 'Son Siparişler')],
            ),
          ),
          Product.products.length == 0
              //TODO init Last Orders
              ? Container(
                  decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(paddingHorizontal)),
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppLargeText(
                        text:
                            'Daha Önceden Ürün Eklemediniz. Görüntülemek için lütfen ürün ekleyin!',
                        align: TextAlign.center,
                      ),
                      Container(
                        padding: EdgeInsets.all(paddingHorizontal),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1,
                            borderRadius:
                                BorderRadius.circular(paddingHorizontal)),
                        child: AppLargeText(text: 'Ürün Ekle'),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: paddingZero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (ctx, index) {
                    return Product_Overview(
                      //TODO Products init Statistic
                      product: Product.products.first,
                    );
                  },
                )
        ],
      ),
    );
  }
}
