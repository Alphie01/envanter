import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:envanterimservetim/screens/essencial/drawer.dart';
import 'package:envanterimservetim/screens/homepage/homepage.dart';
import 'package:envanterimservetim/screens/newProduct/newproduct.dart';
import 'package:envanterimservetim/screens/newTeammate/newTeammate.dart';
import 'package:envanterimservetim/screens/productScreen/product.dart';
import 'package:envanterimservetim/screens/profile/my_profile/my_profile.dart';
import 'package:envanterimservetim/screens/settings/settingsScreen.dart';

import 'package:envanterimservetim/screens/starting/appInfo/appInfo.dart';
import 'package:envanterimservetim/screens/starting/loading/loading.dart';
import 'package:envanterimservetim/screens/starting/login/login.dart';
import 'package:envanterimservetim/screens/starting/openingPage/welcome.dart';
import 'package:envanterimservetim/screens/starting/register/register.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:envanterimservetim/screens/stockspage/stockScreen.dart';
import 'package:envanterimservetim/widgets/ads/adsOfApp.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppNavigatorScreen extends StatefulWidget {
  final int pagecount;

  const AppNavigatorScreen({Key? key, this.pagecount = 0}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppNavigatorScreenState createState() => _AppNavigatorScreenState();
}

class _AppNavigatorScreenState extends State<AppNavigatorScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  // ignore: unused_field
  Animation<double>? _animation;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  // ignore: prefer_final_fields

  List tryed = [{}];
  bool bottombar = true, darkTheme = false, isAuthed = false;

  Widget tabBody = Container(
    color: AppTheme.firstColor,
  );

  int startingPage = 90, pageViewPages = 1;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval((1 / 9) * 0, 1.0, curve: Curves.fastOutSlowIn)));
    _updateBar(pageId: startingPage);
    checkStartingPage();
    super.initState();
  }

  Future<void> scanNormalBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.BARCODE, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      if (Product.findProductByBarcode(barcodeScanResult) != null) {
        Navigator.pop(context);
        Navigator.pop(context);
        _updateBar(pageId: 30);
      } else {
        _showAlertDialogFindedBarcode(context, barcodeScanResult);
      }
    }
  }

  Future<void> scanQRBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.QR, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      if (Product.findProductByBarcode(barcodeScanResult) != null) {
        Navigator.pop(context);
        Navigator.pop(context);
        _updateBar(pageId: 30);
      } else {
        _showAlertDialogFindedBarcode(context, barcodeScanResult);
      }
    }
  }

  void _showAlertDialogFindedBarcode(BuildContext context, String permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          title: AppLargeText(
              text: 'Uyarı! Okuttuğunuz barkod daha önceden kaydedilmeiştir.'),
          content: AppText(
            text:
                'Okutmuş olduğunuz $permission daha önceden işletmenizde kaydedilmemiştir. Yeni kayıt etmek ister misiniz?',
            maxLineCount: 10,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AppText(
                text: 'Vazgeç',
                color: AppTheme.contrastColor1,
              ),
            ),
            TextButton(
              onPressed: () {
                _updateBar(pageId: 20);
                Navigator.of(context).pop();
              },
              child: AppText(
                text: 'Kayıt Et',
                color: AppTheme.alertGreen[0],
              ),
            ),
          ],
        );
      },
    );
  }

  Future checkStartingPage() async {
    await SharedPref.getSharedInstance();
    print(SharedPref.getStringValuesSF(userToken));

    // ignore: unnecessary_null_comparison
    if (SharedPref.getBoolValuesSF(isShownWelcomeInfos)) {
      setState(() {
        startingPage = 92;
      });
    }

    if (SharedPref.getStringValuesSF(userToken) != '') {
      setState(() {
        startingPage = 94;
      });
    }

    if (SharedPref.getBoolValuesSF(darkOrLightMode)) {
      AppTheme.setDarkTheme();
      setState(() {
        darkTheme = true;
      });
    }

    _updateBar(pageId: startingPage);
  }

  int currIndex = 0;
  void _updateBar({int pageId = 0, Map pageContent = const {}}) {
    setState(() {
      startingPage = pageId;
    });
    print(startingPage);
    animationController?.reverse().then<dynamic>((data) {
      if (!mounted) {
        return;
      }

      switch (pageId) {
        case 0:
          setState(() {
            currIndex = 0;
            bottombar = true;
            tabBody = HomeScreen(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
              closeBottomBar: (bool selection) {
                setState(() {
                  bottombar = selection;
                });
              },
            );
          });
          break;
        case 1:
          setState(() {
            currIndex = 0;
            bottombar = true;
            tabBody = NewTeammate(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 10:
          setState(() {
            currIndex = 1;
            bottombar = true;
            tabBody = StockPage(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 11:
          setState(() {
            currIndex = 1;
            bottombar = true;
            tabBody = ProductPage(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 20:
          setState(() {
            currIndex = 2;
            bottombar = true;
            tabBody = NewShopProductPage(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
              barkod: pageContent['barkod'] ?? '',
            );
          });
          break;

        case 30:
          setState(() {
            currIndex = 3;
            bottombar = true;
            tabBody = MainSettingsPage(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 31:
          setState(() {
            currIndex = 3;
            bottombar = true;
            tabBody = MyProfile(
              scaffoldKey: scaffoldKey,
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 90:
          setState(() {
            bottombar = false;
            tabBody = WelcomeScreen(
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 91:
          setState(() {
            bottombar = false;
            tabBody = AppInfo(
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 92:
          setState(() {
            bottombar = false;
            tabBody = LoginScreen(
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;

        case 93:
          setState(() {
            bottombar = false;
            tabBody = RegisterScreen(
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
          break;
        case 94:
          setState(() {
            bottombar = false;
            tabBody = LoadingScreen(
              isOnlyThemeChange: pageContent['isOnlyTheme'] ?? false,
              animationController: animationController,
              isAuthed: isAuthed,
              setAutentication: () {
                setState(() {
                  isAuthed = true;
                });
              },
              updatePage: _updateBar,
            );
          });
          break;

        default:
          setState(() {
            tabBody = WelcomeScreen(
              animationController: animationController,
              updatePage: _updateBar,
            );
          });
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SharedPref.init();
    return Container(
      color: AppTheme.background1,
      child: bottombar
          ? Scaffold(
              key: scaffoldKey,
              drawer: Drawer(
                backgroundColor: AppTheme.background,
                child: Drawers(
                  darkTheme: darkTheme,
                  updatePage: _updateBar,
                ),
              ),
              bottomNavigationBar: CurvedNavigationBar(
                index: currIndex,
                backgroundColor: AppTheme.firstColor.withOpacity(.3),
                height: AppBar().preferredSize.height,
                color: AppTheme.background1,
                items: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.home,
                    color: AppTheme.textColor,
                  ),
                  FaIcon(
                    FontAwesomeIcons.box,
                    color: AppTheme.textColor,
                  ),
                  FaIcon(
                    FontAwesomeIcons.qrcode,
                    color: AppTheme.textColor,
                  ),
                  FaIcon(
                    FontAwesomeIcons.cog,
                    color: AppTheme.textColor,
                  ),
                ],
                onTap: (index) {
                  switch (index) {
                    case 0:
                      _updateBar(pageId: 0);
                      break;
                    case 1:
                      _updateBar(pageId: 10);
                      break;
                    case 2:
                      showModalBottomSheet(
                        context: context,
                        builder: (builder) {
                          return Container(
                            color: AppTheme.background1,
                            padding: EdgeInsets.only(bottom: paddingHorizontal),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    child: AppText(
                                        fontWeight: FontWeight.w600,
                                        text:
                                            'Nasıl Bir İşlem Yapmak İstersiniz')),
                                GestureDetector(
                                  onTap: () {
                                    _updateBar(pageId: 20);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.camera,
                                            color: AppTheme.textColor),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: paddingHorizontal),
                                          child: AppText(
                                              text: 'Yeni Ürün Oluştur'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (cont) {
                                        return Container(
                                          color: AppTheme.background1,
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  getPaddingScreenBottomHeight(),
                                              left: paddingHorizontal,
                                              right: paddingHorizontal,
                                              top: paddingHorizontal),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AppLargeText(
                                                text:
                                                    'Nasıl İşlem Yapmak İstersiniz?',
                                                color: AppTheme.textColor,
                                              ),
                                              GestureDetector(
                                                onTap: scanNormalBarcode,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          paddingHorizontal),
                                                  child: Row(
                                                    children: [
                                                      FaIcon(
                                                          FontAwesomeIcons
                                                              .barcode,
                                                          color: AppTheme
                                                              .textColor),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left:
                                                                paddingHorizontal),
                                                        child: AppText(
                                                            text:
                                                                'Barkod İle İşlem Yapmak İstiyorum'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: scanQRBarcode,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          paddingHorizontal),
                                                  child: Row(
                                                    children: [
                                                      FaIcon(
                                                          FontAwesomeIcons
                                                              .qrcode,
                                                          color: AppTheme
                                                              .textColor),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left:
                                                                paddingHorizontal),
                                                        child: AppText(
                                                            text:
                                                                'QR Kod İle İşlem Yapmak İstiyorum'),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    /* Navigator.pop(context); */
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.qrcode,
                                            color: AppTheme.textColor),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: paddingHorizontal),
                                          child: AppText(
                                              text: 'Olan Ürünün Girişini Yap'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (!Shop.selectedShop!.shopPermissions
                                        .shop_can_sell_products) {
                                      showAdsOfApp(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.qrcode,
                                            color: AppTheme.textColor),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: paddingHorizontal),
                                          child: AppText(
                                              text: 'Yeni Sipariş Oluştur'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );

                      break;

                    case 3:
                      _updateBar(pageId: 30);
                      break;

                    default:
                  }
                },
              ),
              backgroundColor: Colors.transparent,
              body: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return Stack(
                      children: <Widget>[tabBody],
                    );
                  }
                },
              ),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: FutureBuilder<bool>(
                future: getData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return Stack(
                      children: <Widget>[tabBody],
                    );
                  }
                },
              ),
            ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
