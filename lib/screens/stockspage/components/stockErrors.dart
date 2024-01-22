import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/stockspage/components/productDoneStock.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductErrors extends StatefulWidget {
  const ProductErrors({super.key, required this.showErrorSet});
  final Function showErrorSet;
  @override
  State<ProductErrors> createState() => _ProductErrorsState();
}

class _ProductErrorsState extends State<ProductErrors> {
  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLargeText(
                  text: 'Uyarılar',
                ),
                GestureDetector(
                  onTap: () {
                    widget.showErrorSet();
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: paddingHorizontal / 2),
                        child: AppLargeText(
                          text: 'Kapat',
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.x,
                        size: 16,
                        color: AppTheme.textColor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
            child: AppText(
              text:
                  'Bu kısımda keşfettiğimiz ve düzeltmenizi gördüğümüz hataları-değişiklikleri görüntüleyebilirsiniz!',
            ),
          ),
          Box_View(
            horizontal: 0,
            color: AppTheme.background,
            boxInside: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLargeText(
                        text: 'Fiyat Çakışması',
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: AppLargeText(
                              text: 'Temizle',
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.x,
                            color: AppTheme.textColor,
                            size: 14,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: paddingHorizontal),
                  height: 200,
                  child: ListView.builder(
                    itemCount: 5,
                    padding: paddingZero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.only(right: paddingHorizontal),
                        width: MediaQuery.of(context).size.width * .6,
                        decoration: BoxDecoration(
                          //TODO networkImage   Tekrar Bak!
                          color: Colors.black,
                          borderRadius: defaultRadius,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppTheme.background.withOpacity(.8),
                              borderRadius: defaultRadius),
                          padding: EdgeInsets.all(paddingHorizontal / 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text:
                                    'lorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsumlorem ipsum ',
                                fontWeight: FontWeight.bold,
                                maxLineCount: 1,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(top: paddingHorizontal / 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: 'Maliyet',
                                          fontWeight: FontWeight.bold,
                                          maxLineCount: 1,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AppText(text: '111₺'),
                                            Container(
                                              padding: EdgeInsets.only(left: 5),
                                              child: AppText(
                                                text: "10\$",
                                                size: 9,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        AppText(
                                          text: 'Satılan Fiyat',
                                          fontWeight: FontWeight.bold,
                                          maxLineCount: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              child: AppText(
                                                text: "10\$",
                                                size: 9,
                                              ),
                                            ),
                                            AppText(text: '111₺'),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Box_View(
            horizontal: 0,
            color: AppTheme.background,
            boxInside: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLargeText(
                        text: 'Stok Uyarısı',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: paddingHorizontal,
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: Product.lowStockProducts().length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: paddingZero,
                        itemBuilder: (ctx, index) {
                          return ProductDoneStock(
                            product: Product.lowStockProducts()[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stoğu Olmayan Ürünler

          Box_View(
            horizontal: 0,
            color: AppTheme.background,
            boxInside: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: paddingHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLargeText(
                        text: 'Stoğu Bulunmayan Ürünler',
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: paddingHorizontal,
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: Product.doneStockProducts().length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: paddingZero,
                        itemBuilder: (ctx, index) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 5),
                            child: ProductDoneStock(
                              product: Product.doneStockProducts()[index],
                              isNoneStock: true,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
