import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/ads/adsOfApp.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class HeaderWidget extends StatelessWidget {
  HeaderWidget({
    super.key,
    required this.headerColor,
    required this.headerIconColor,
    required this.scaffoldKey,
    required this.updatePage,
    required this.blurOpacity,
  });

  final Color headerColor;
  final Color headerIconColor;
  final double blurOpacity;
  final Function updatePage;

  final GlobalKey<ScaffoldState> scaffoldKey;

  bool deneme = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: getPaddingScreenTopHeight()),
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(paddingHorizontal)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.contrastColor1.withOpacity(blurOpacity),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, 7), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        height: AppBar().preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: FaIcon(
                    FontAwesomeIcons.bars,
                    color: headerIconColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: paddingHorizontal),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: AppBar().preferredSize.height -
                            1.75 * paddingHorizontal,
                        width: AppBar().preferredSize.height -
                            1.75 * paddingHorizontal,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AppTheme.logo,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: paddingHorizontal / 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Envanterim',
                              size: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: 'İş Hayatım',
                              size: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                /* GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (builder) {
                        return Container();
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: paddingHorizontal * 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.envelope,
                          color: AppTheme.textColor,
                        ),
                        Shop.selectedShop!.shopPermissions
                                .shop_can_add_teammates
                            ? Transform.translate(
                                offset: Offset(12, -12),
                                child: Container(
                                  padding: EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                      color: AppTheme.alertRed[0],
                                      shape: BoxShape.circle),
                                  child: AppText(text: '1'),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ), */
                GestureDetector(
                  onTap: () {
                    if (Shop
                        .selectedShop!.shopPermissions.shop_can_add_teammates) {
                      updatePage(pageId: 1);
                    } else {
                      showAdsOfApp(context);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.user,
                        color: AppTheme.textColor,
                      ),
                      Shop.selectedShop!.shopPermissions.shop_can_add_teammates
                          ? Transform.translate(
                              offset: Offset(12, -12),
                              child: Container(
                                padding: EdgeInsets.all(7.5),
                                decoration: BoxDecoration(
                                    color: AppTheme.alertRed[0],
                                    shape: BoxShape.circle),
                                child: AppText(
                                    text:
                                        '${Shop.selectedShop!.waitingApprove.length}'),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
