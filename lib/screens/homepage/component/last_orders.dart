import 'package:envanterimservetim/core/classes/brand.dart';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
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
          Siparis.lastSiparis.isEmpty
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
                  itemCount: Siparis.lastSiparis.length,
                  itemBuilder: (ctx, index) {
                    Siparis _siparis = Siparis.lastSiparis[index];
                    return Siparis_Overview(
                      siparis: _siparis,
                    );
                  },
                )
        ],
      ),
    );
  }
}

class Siparis_Overview extends StatelessWidget {
  const Siparis_Overview({
    super.key,
    required this.siparis,
  });

  final Siparis siparis;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(paddingHorizontal)),
      padding: EdgeInsets.all(paddingHorizontal),
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: NetworkContainer(
              imageUrl: siparis.product.images!.isNotEmpty
                  ? siparis.product.images!.first
                  : const NetworkImage(
                      'http://robolink.com.tr/products/products.png'),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppLargeText(
                    text: siparis.product.title!,
                  ),
                  AppText(
                    maxLineCount: 1,
                    text: 'Barkod: ${siparis.product.barcode!}',
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: paddingHorizontal / 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLargeText(text: 'Sipariş Stok Kodu'),
                                AppText(
                                    text:
                                        '${siparis.selectedSizelist.stockCode}'),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppLargeText(text: 'Sipariş \nSayısı'),
                              AppText(text: '${siparis.count}'),
                            ],
                          ),
                        ],
                      )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: paddingHorizontal / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargeText(text: 'Sipariş Stok İsmi'),
                                  AppText(
                                      text:
                                          '${siparis.selectedSizelist.nameOfSize}'),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLargeText(text: 'Sipariş Satış Fiyatı'),
                                AppText(
                                    text:
                                        '${siparis.salePrice} ${siparis.saleCurrency}'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
