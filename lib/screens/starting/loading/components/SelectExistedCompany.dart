import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectExistedCompany extends StatefulWidget {
  const SelectExistedCompany({
    super.key,
    required this.approved,
    required this.goBackToFirstPage,
  });

  final Function(String) approved;
  final Function goBackToFirstPage;
  @override
  State<SelectExistedCompany> createState() => _SelectExistedCompanyState();
}

class _SelectExistedCompanyState extends State<SelectExistedCompany> {
  bool isResulted = false, isFetching = false, isException = false;
  Shop? _selectedExisted;
  String exception = '';
  Future<void> scanQRBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.QR, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      setState(() {
        isFetching = true;
        _fetchFromServer(barcodeScanResult);
      });
    }
  }

  Future<void> _fetchFromServer(String scanedCode) async {
    Shop? result = await Shop.fetchExistedShop(scanedCode);
    if (result != null) {
      setState(() {
        isFetching = false;
        isResulted = true;
        _selectedExisted = result;
      });
    } else {
      setState(() {
        isFetching = false;
        isResulted = false;
      });
    }
  }

  Future<void> _enterToShop() async {
    setState(() {
      isFetching = true;
    });
    Map? returns = await Shop.joinExistedShop(
        '${_selectedExisted!.shop_id}', User.userProfile!.userId!);
    if (returns != null) {
      if (returns['exeption'] != null) {
        setState(() {
          isException = true;
          exception = returns['exeption'];
        });
      } else {
        Shop.setSelectedShop(_selectedExisted!);
        widget.approved(returns['token']);
      }
      setState(() {
        isFetching = false;
      });
    }
  }

//TODO Yalnış Okumada Uyarı Çıkar
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          padding: paddingZero,
          children: [
            Logo(),
            Container(
              padding: EdgeInsets.all(paddingHorizontal * 2),
              child: AppText(
                text: 'Olan Bir Şirkete Katılmak istiyorum',
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
                size: 14,
                align: TextAlign.center,
              ),
            ),
            isFetching
                ? Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : isResulted
                    ? Box_View(
                        boxInside: SingleChildScrollView(
                          child: isException
                              ? Container(
                                  padding: EdgeInsets.all(paddingHorizontal),
                                  child: AppText(
                                    text: '$exception',
                                    maxLineCount: 10,
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: NetworkContainer(
                                          imageUrl:
                                              _selectedExisted!.shop_image),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: paddingHorizontal),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'İşletmenin İsimi',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          AppText(
                                            text:
                                                '${_selectedExisted!.shop_name}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: paddingHorizontal),
                                      child: AppText(
                                        text: _selectedExisted!.shopPrivacy == 1
                                            ? "İşletme gizlilik açısından açık konumdadır. 'Direk Katıl' butonuna basarak sizlerde işletmeye giriş yapabilirsiniz."
                                            : 'İşletme gizlilik açısından kapalı konumdadır. İşletmye giriş yapmanız için öncelikle işletme yetkililerinin sizi onaylaması lazımdır.',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _enterToShop,
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(paddingHorizontal),
                                        decoration: BoxDecoration(
                                            color: AppTheme.contrastColor1,
                                            borderRadius: BorderRadius.circular(
                                                paddingHorizontal)),
                                        child:
                                            _selectedExisted!.shopPrivacy == 1
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text: 'Direk Katıl',
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            'Katılmak İçin İzin İste',
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: paddingHorizontal,
                                    ),
                                    GestureDetector(
                                      onTap: scanQRBarcode,
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(paddingHorizontal),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppTheme.contrastColor1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                paddingHorizontal)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                              text: 'Tekrar Okut',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(paddingHorizontal * 2),
                            child: AppText(
                              text:
                                  'Katılmak istediğiniz işletmenin qr kodunu okutarak sizlerde işletmeye katılma isteği gönderebilirsiniz.',
                              color: AppTheme.white,
                              align: TextAlign.center,
                            ),
                          ),
                          GestureDetector(
                            onTap: scanQRBarcode,
                            child: Box_View(
                              boxInside: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text:
                                              'Olan Bir İşletmenin Altına Giriş Yap',
                                          fontWeight: FontWeight.bold,
                                          size: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.qrcode,
                                    color: AppTheme.textColor,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
          ],
        ),
        GestureDetector(
          onTap: () {
            widget.goBackToFirstPage();
          },
          child: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 36,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
