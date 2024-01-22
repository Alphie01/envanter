import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/homepage/component/introduce.dart';
import 'package:envanterimservetim/screens/homepage/component/last_orders.dart';
import 'package:envanterimservetim/screens/homepage/component/mostsellers.dart';
import 'package:envanterimservetim/screens/homepage/component/salesByType.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:envanterimservetim/widgets/refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey,
      this.closeBottomBar})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage, closeBottomBar;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isSelectedCategory = false;
  bool isTopRefresh = false, refreshData = false;

  final ScrollController scrollController = ScrollController();
  bool showRecentSearchs = false, showFilters = false, showAppbar = false;
  Animation<double>? topBarAnimation;
  double topBarOpacity = 0.0, searchBarOpacity = .6, offset = 0;
  PageController? _pageController;

  //⁡⁣⁣⁢top Header Animations⁡
  AnimationController? filterAnimation, headerAnimationController;
  Animation<double>? filterOpacity, filterTransform, headerAnimation;
  Color iconColor = AppTheme.textColor;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    headerAnimationController =
        AnimationController(vsync: this, duration: defaultDuration);

    headerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(headerAnimationController!);

    super.initState();
    widget.animationController!.forward();
    scrollController.addListener(() {
      setState(() {
        offset = scrollController.offset;
      });
      if (scrollController.offset > 60) {
        headerAnimationController!.forward();
      } else {
        headerAnimationController!.reverse();
      }
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              AnimatedBuilder(
                animation: widget.animationController!,
                builder: (BuildContext context, Widget? child) {
                  return FadeTransition(
                    opacity: topBarAnimation!,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                      child: PageView(
                        controller: _pageController,
                        children: [
                          PageScanBarcode(
                            updatePage: widget.updatePage,
                          ),
                          Container(
                            width: double.maxFinite,
                            child: ListView(
                              controller: scrollController,
                              padding: paddingZero,
                              shrinkWrap: true,
                              children: [
                                HomeWelcome(
                                  updatePage: widget.updatePage!,
                                ),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: paddingHorizontal),
                                        child: AppLargeText(
                                          text: 'Son Eklenen Ürünler',
                                        ),
                                      ),
                                      Product.products.length == 0
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.background,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          paddingHorizontal)),
                                              height: 250,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  AppLargeText(
                                                    text:
                                                        'Daha Önceden Ürün Eklemediniz. Görüntülemek için lütfen ürün ekleyin!',
                                                    align: TextAlign.center,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                        paddingHorizontal),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .contrastColor1,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                paddingHorizontal)),
                                                    child: AppLargeText(
                                                        text: 'Ürün Ekle'),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: paddingZero,
                                                itemCount:
                                                    Product.lastFiveProducts()
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  Product product = Product
                                                          .lastFiveProducts()[
                                                      index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Product
                                                          .setSelectedProduct(
                                                              product);
                                                      widget.updatePage!(
                                                          pageId: 11);
                                                    },
                                                    child: Product_Overview(
                                                        product: product),
                                                  );
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                MostSelers(),
                                StorageOfCompany(),
                                LastOrders(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
              Refresh_widget(
                scrollOffset: offset,
                refreshPage: () {},
              ),
              AnimatedBuilder(
                animation: headerAnimation!,
                builder: (BuildContext context, Widget? child) {
                  return HeaderWidget(
                    headerColor:
                        AppTheme.background.withOpacity(headerAnimation!.value),
                    blurOpacity: headerAnimation!.value,
                    headerIconColor: iconColor,
                    scaffoldKey: widget.scaffoldKey,
                    updatePage: widget.updatePage!,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StorageOfCompany extends StatelessWidget {
  const StorageOfCompany({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppLargeText(
                  text: 'Deponda Bulunan Ürünler',
                ),
              ),
              AppLargeText(
                text: 'Haftalık',
                color: AppTheme.contrastColor4,
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: paddingHorizontal),
            child: SalesByType(),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Container(
                    padding: EdgeInsets.all(paddingHorizontal),
                    decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(paddingHorizontal))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AppText(text: 'Detaylı Ürün Satış Dağılımın')
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppTheme.contrastColor1,
                  borderRadius: BorderRadius.circular(paddingHorizontal)),
              padding: EdgeInsets.symmetric(
                  vertical: paddingHorizontal / 2,
                  horizontal: paddingHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: 'Bütün Satış Dağılımlarına Göz At!',
                    color: AppTheme.white,
                  ),
                  FaIcon(
                    FontAwesomeIcons.search,
                    size: 16,
                    color: AppTheme.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Product_Overview extends StatelessWidget {
  const Product_Overview({
    super.key,
    required this.product,
  });

  final Product product;

  String _pricesSizeListPrice(List<SizeList>? list) {
    if (list == null) {
      return ''; // Liste null, boş veya tek bir öğe içeriyorsa boş bir dize döndür
    }
    if (list.length <= 1) {
      return '${list.first.listPrice}'; // Liste null, boş veya tek bir öğe içeriyorsa boş bir dize döndür
    }

    double maxPrice = double.negativeInfinity;
    double minPrice = double.infinity;

    for (var element in list) {
      double price =
          element.listPrice; // Eğer listPrice null ise 0 olarak kabul et

      if (price > maxPrice) {
        maxPrice = price;
      }

      if (price < minPrice) {
        minPrice = price;
      }
    }

    return '$maxPrice - $minPrice';
  }

  String _pricesSizeSalePrice(List<SizeList>? list) {
    if (list == null) {
      return ''; // Liste null, boş veya tek bir öğe içeriyorsa boş bir dize döndür
    }
    if (list.length <= 1) {
      return '${list.first.salePrice}'; // Liste null, boş veya tek bir öğe içeriyorsa boş bir dize döndür
    }

    double maxPrice = double.negativeInfinity;
    double minPrice = double.infinity;

    for (var element in list) {
      double price =
          element.salePrice; // Eğer listPrice null ise 0 olarak kabul et

      if (price > maxPrice) {
        maxPrice = price;
      }

      if (price < minPrice) {
        minPrice = price;
      }
    }

    return '$maxPrice - $minPrice';
  }

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
              imageUrl: product.images!.length != 0
                  ? product.images!.first
                  : NetworkImage(
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
                    text: product.title!,
                  ),
                  AppText(
                    maxLineCount: 1,
                    text: 'Barkod: ${product.barcode!}',
                  ),
                  product.category != null
                      ? AppText(
                          maxLineCount: 1,
                          text: 'Kategori: ${product.category!.name}',
                        )
                      : Container(),
                  AppText(
                    maxLineCount: 1,
                    text: 'Ekleten Kişi: ${product.adderUserName!}',
                  ),
                  AppText(
                      text:
                          'Alış Fiyatı: ${_pricesSizeListPrice(product.sizeLists)} '),
                  AppText(
                      text:
                          'Satış Fiyatı: ${_pricesSizeSalePrice(product.sizeLists)} '),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageScanBarcode extends StatefulWidget {
  const PageScanBarcode({
    super.key,
    this.updatePage,
  });

  final Function? updatePage;
  @override
  State<PageScanBarcode> createState() => _PageScanBarcodeState();
}

class _PageScanBarcodeState extends State<PageScanBarcode> {
  String barcode = '';
  Product? findedProduct;
  bool initProduct = false, fetching = false, doesntScaned = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), () {
        scanNormalBarcode();
      });
    });
  }

  Future<void> scanNormalBarcode() async {
    setState(() {
      initProduct = false;
      doesntScaned = true;
      fetching = !fetching;
    });
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.BARCODE, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      setState(() {
        barcode = barcodeScanResult;
        findedProduct = Product.findProductByBarcode(barcode);
        if (findedProduct != null) {
          initProduct = true;
        }

        fetching = !fetching;
      });
    } else {
      setState(() {
        doesntScaned = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: doesntScaned
          ? fetching
              ? Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppTheme.contrastColor1,
                    ),
                  ),
                )
              : initProduct
                  ? ListView(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: AppTheme.background1),
                          height: MediaQuery.of(context).size.height * .6,
                          child: findedProduct!.images!.isNotEmpty
                              ? PageView.builder(
                                  itemCount: findedProduct!.images!.length,
                                  itemBuilder: (itemBuilder, index) {
                                    return NetworkContainer(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(
                                              paddingHorizontal)),
                                      imageUrl: findedProduct!.images![index],
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(
                                                paddingHorizontal),
                                            alignment: Alignment.center,
                                            height: 25,
                                            child: ListView.builder(
                                              padding: paddingZero,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  findedProduct!.images!.length,
                                              itemBuilder: (ctx, ind) {
                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  width: 15,
                                                  height: 15,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.background1,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(2.5),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: ind <= index
                                                          ? AppTheme.textColor
                                                          : null,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const NetworkContainer(
                                  imageUrl: NetworkImage(
                                      'http://robolink.com.tr/products/products.png'),
                                ),
                        ),
                        Box_View(
                          vertical: paddingHorizontal,
                          boxInside: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: AppLargeText(
                                          text: '${findedProduct!.title}')),
                                  GestureDetector(
                                    onTap: scanNormalBarcode,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: paddingHorizontal / 2),
                                          child:
                                              AppLargeText(text: 'Tekrar Okut'),
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.barcode,
                                          color: AppTheme.textColor,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              AppText(
                                  text:
                                      'Ürünün Barkodu : ${findedProduct!.barcode}'),
                              AppText(text: '${findedProduct!.description}')
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: paddingHorizontal),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          AppText(
                            align: TextAlign.center,
                            size: 18,
                            text:
                                'Aradığınız $barcode bulunamamıştır. İsterseniz tekrar deneyiniz, isterseniz bu ürünü kaydediniz.',
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: scanNormalBarcode,
                                child: Box_View(
                                  boxInside: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Tekrar Okut',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.barcode,
                                        color: AppTheme.textColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: paddingHorizontal),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.updatePage!(
                                        pageId: 20,
                                        pageContent: {'barkod': barcode});
                                  },
                                  child: Box_View(
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Yeni Ürün Olarak Ekle',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: AppTheme.textColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppText(
                    align: TextAlign.center,
                    size: 18,
                    text:
                        'Aradığınız barkod okutulmamıştır. İsterseniz tekrar deneyiniz, isterseniz bu ürünü kaydediniz.',
                  ),
                  GestureDetector(
                    onTap: scanNormalBarcode,
                    child: Box_View(
                      boxInside: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Tekrar Okut',
                            fontWeight: FontWeight.bold,
                          ),
                          FaIcon(
                            FontAwesomeIcons.barcode,
                            color: AppTheme.textColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
