import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/statics/statics_linegraph.dart';
import 'package:envanterimservetim/screens/homepage/component/fastProcess.dart';
import 'package:envanterimservetim/widgets/ads/adsOfApp.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/expandedPageview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeWelcome extends StatelessWidget {
  const HomeWelcome({
    super.key,
    required this.updatePage,
  });

  final Function updatePage;

  void checkerOf(int pageIdSended, BuildContext context, bool checker) {
    if (checker) {
      updatePage(pageId: pageIdSended);
    } else {
      showAdsOfApp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        color: AppBlackTheme.homeContainer,
        boxShadow: [
          BoxShadow(
            color: AppTheme.contrastColor1.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 7), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.only(
          left: paddingHorizontal,
          right: paddingHorizontal,
          bottom: paddingHorizontal,
          top: getPaddingScreenTopHeight() * 2 + AppBar().preferredSize.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: User.userProfile!.userProfilePhoto,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        text: '${User.userProfile!.userName}',
                        fontWeight: FontWeight.w600,
                        color: AppBlackTheme.white,
                      ),
                      AppText(
                        text: '${Shop.selectedShop!.shop_name}',
                        color: Colors.white,
                      ),
                      AppText(
                        text:
                            '${Shop.permissionLevel(Shop.selectedShop!.userPermissionLevel!)}',
                        color: AppBlackTheme.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .45,
                  child: PageView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: paddingHorizontal),
                        child: Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              padding: paddingZero,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisSpacing: paddingHorizontal,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: paddingHorizontal,
                              crossAxisCount: 2,
                              children: <Widget>[
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(10, context, true);
                                  },
                                  containerName:
                                      '${Product.products.length} Ürün',
                                  containerSubText: 'Toplam Ürün Sayısı',
                                  containerIconData: FontAwesomeIcons.plus,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_initilize_low_stok);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_initilize_low_stok
                                      ? '${Product.lowStockProducts().length} Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Düşük Stok',
                                  containerIconData: FontAwesomeIcons.warning,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_initilize_low_stok);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_initilize_low_stok
                                      ? '${Product.doneStockProducts().length} Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Stokta Olmayan',
                                  containerIconData: FontAwesomeIcons.a,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_init_reminder);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_init_reminder
                                      ? '4 Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Hatırlatma',
                                  containerIconData: FontAwesomeIcons.clock,
                                ),
                              ],
                            ),
                            PageInducator(
                              containerindex: 0,
                              totalCount: 3,
                              string: 'Ürün Bilgilendirmesi',
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: paddingHorizontal),
                        child: Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              padding: paddingZero,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisSpacing: paddingHorizontal,
                              childAspectRatio: 1.5,
                              mainAxisSpacing: paddingHorizontal,
                              crossAxisCount: 2,
                              children: <Widget>[
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(10, context, true);
                                  },
                                  containerName:
                                      '${Product.products.length} Ürün',
                                  containerSubText: 'Yetkili Kullanıcı',
                                  containerIconData: FontAwesomeIcons.user,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_initilize_low_stok);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_initilize_low_stok
                                      ? '${Product.lowStockProducts().length} Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Kullanıcı',
                                  containerIconData: FontAwesomeIcons.user,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_initilize_low_stok);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_initilize_low_stok
                                      ? '${Product.doneStockProducts().length} Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Dönem Ürün Çıkışı',
                                  containerIconData: FontAwesomeIcons.a,
                                ),
                                FastProcess(
                                  containerFunction: () {
                                    checkerOf(
                                        10,
                                        context,
                                        Shop.selectedShop!.shopPermissions
                                            .shop_can_init_reminder);
                                  },
                                  containerName: Shop
                                          .selectedShop!
                                          .shopPermissions
                                          .shop_can_init_reminder
                                      ? '4 Ürün'
                                      : 'Kilitli',
                                  containerSubText: 'Dönem Ürün Girişi',
                                  containerIconData: FontAwesomeIcons.clock,
                                ),
                              ],
                            ),
                            PageInducator(
                              containerindex: 1,
                              totalCount: 3,
                              string: 'İşletme Bilgileri',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageInducator extends StatelessWidget {
  const PageInducator({
    super.key,
    required this.string,
    required this.totalCount,
    required this.containerindex,
  });
  final String string;
  final int totalCount, containerindex;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: paddingHorizontal),
      child: Column(
        children: [
          Container(
            height: 15,
            child: ListView.builder(
              itemCount: totalCount,
              padding: paddingZero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 15,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 15,
                  padding: EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    color: AppTheme.textColor,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          containerindex >= index ? AppTheme.background1 : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: paddingHorizontal / 2),
            child: AppText(
              text: string,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
