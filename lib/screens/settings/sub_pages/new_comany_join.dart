import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/loadingCircular.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewCompanyJoin extends StatefulWidget {
  const NewCompanyJoin({
    super.key,
  });

  @override
  State<NewCompanyJoin> createState() => _NewCompanyJoinState();
}

class _NewCompanyJoinState extends State<NewCompanyJoin> {
  bool isFetching = false, isFetched = false;
  String shopAccessKey = '', exception = '';
  Shop? _selectedExisted;
  TextEditingController textEditingController = TextEditingController();

  Future<void> _fetchFromServer(String scanedCode) async {
    setState(() {
      isFetching = true;
      isFetched = true;
    });
    Shop? result = await Shop.fetchExistedShop(scanedCode);
    print(result);

    if (result != null) {
      setState(() {
        isFetching = false;
        _selectedExisted = result;
      });
    } else {
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> _enterToShop() async {
    setState(() {
      isFetching = true;
    });
    Map? returns = await Shop.joinExistedShop(
        '${_selectedExisted!.shop_id}', User.userProfile!.userId!);
    print(returns);
    if (returns != null) {
      if (returns['exeption'] != null) {
        setState(() {
          exception = returns['exeption'];
        });
      } else {
        Shop.setSelectedShop(_selectedExisted!);
      }
      setState(() {
        isFetching = false;
      });
    }
  }

  Future<void> scanQRBarcode() async {
    String barcodeScanResult = await BarcodeReader.scanQRBarcode();

    if (barcodeScanResult != '-1') {
      setState(() {
        textEditingController.text = barcodeScanResult;
        _fetchFromServer(barcodeScanResult);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            child: AppLargeText(
              text: 'Yeni İşletmeye Katıl',
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            child: AppText(
              text:
                  'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
            ),
          ),
          Box_View(
            horizontal: 0,
            color: AppTheme.background,
            vertical: 0,
            boxInside: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        controller: textEditingController,
                        hintText: 'Katılmak İstediğiniz İşletme Kodu',
                        onChange: (val) {
                          setState(() {
                            shopAccessKey = val;
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _fetchFromServer(shopAccessKey),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(
                            horizontal: paddingHorizontal * .5),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1.withOpacity(.6),
                            shape: BoxShape.circle),
                        child: FaIcon(
                          FontAwesomeIcons.search,
                          color: AppTheme.textColor,
                          size: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: scanQRBarcode,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: paddingHorizontal * .5),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1.withOpacity(.6),
                            shape: BoxShape.circle),
                        child: FaIcon(
                          FontAwesomeIcons.qrcode,
                          color: AppTheme.textColor,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
                isFetched
                    ? isFetching
                        ? Container(
                            margin: EdgeInsets.only(top: paddingHorizontal),
                            child: LoadingCircular(),
                          )
                        : _selectedExisted != null
                            ? SettingsNewShopInfo(
                                shop: _selectedExisted,
                                onClick: _enterToShop,
                                exception: exception,
                              )
                            : Container()
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsNewShopInfo extends StatelessWidget {
  const SettingsNewShopInfo({
    super.key,
    this.shop,
    required this.onClick,
    this.exception,
  });
  final Shop? shop;
  final Function onClick;
  final String? exception;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: paddingHorizontal * .5),
      child: Box_View(
        horizontal: 0,
        vertical: 0,
        boxInside: Column(
          children: [
            Row(
              children: [
                AppLargeText(
                  text: shop!.shop_name,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
              child: AppText(
                text: shop!.shopPrivacy == 1
                    ? "İşletme gizlilik açısından açık konumdadır. 'Direk Katıl' butonuna basarak sizlerde işletmeye giriş yapabilirsiniz."
                    : 'İşletme gizlilik açısından kapalı konumdadır. İşletmye giriş yapmanız için öncelikle işletme yetkililerinin sizi onaylaması lazımdır.',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => onClick(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingHorizontal * .5),
                    color: AppTheme.contrastColor1.withOpacity(.6),
                    child: AppLargeText(text: 'Katıl'),
                  ),
                ),
              ],
            ),
            exception != ''
                ? Container(
                    padding: EdgeInsets.only(top: paddingHorizontal * .5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.warning,
                          color: AppTheme.textColor,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: paddingHorizontal),
                            child: AppText(
                              text: exception!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
