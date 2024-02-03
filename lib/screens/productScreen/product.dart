import 'dart:io';
import 'dart:ui';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/homepage/component/fastProcess.dart';
import 'package:envanterimservetim/screens/productScreen/component/simular_products.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductPage extends StatefulWidget {
  const ProductPage(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation,
      filterOpacity,
      filterTransform,
      headerAnimation;
  AnimationController? filterAnimation, headerAnimationController;
  ScrollController _scrollController = ScrollController();
  Color iconColor = AppTheme.textColor;
  double topBarOpacity = 0.0, searchBarOpacity = .6;

  Product? _products;
  List<Product>? randomProducts;
  @override
  void initState() {
    /* connectServer(); */
    setState(() {
      _products = Product.selectedProduct;
      randomProducts = Product.getRandomObjects(3);
    });

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    headerAnimationController =
        AnimationController(vsync: this, duration: defaultDuration);

    headerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(headerAnimationController!);
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        headerAnimationController!.forward();
      } else {
        headerAnimationController!.reverse();
      }
    });

    super.initState();
    widget.animationController!.forward();
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
          onPanUpdate: (details) {},
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
                      child: Container(
                        /* margin: EdgeInsets.only(
                            top: getPaddingScreenTopHeight() +
                                AppBar().preferredSize.height), */
                        width: double.maxFinite,
                        child: ListView(
                          padding: paddingZero,
                          shrinkWrap: true,
                          controller: _scrollController,
                          children: [
                            Container(
                              decoration:
                                  BoxDecoration(color: AppTheme.background1),
                              height: MediaQuery.of(context).size.height * .6,
                              child: _products!.images!.isNotEmpty
                                  ? PageView.builder(
                                      itemCount: _products!.images!.length,
                                      itemBuilder: (itemBuilder, index) {
                                        return NetworkContainer(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(
                                                  paddingHorizontal)),
                                          imageUrl: _products!.images![index],
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
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      _products!.images!.length,
                                                  itemBuilder: (ctx, ind) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      width: 15,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .background1,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(2.5),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ind <= index
                                                              ? AppTheme
                                                                  .textColor
                                                              : null,
                                                          shape:
                                                              BoxShape.circle,
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
                                      AppLargeText(text: '${_products!.title}'),
                                      FaIcon(
                                        FontAwesomeIcons.cog,
                                        color: AppTheme.textColor,
                                      )
                                    ],
                                  ),
                                  AppText(
                                      text:
                                          'Ürünün Barkodu : ${_products!.barcode}'),
                                  AppText(text: '${_products!.description}')
                                ],
                              ),
                            ),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Bu Ürünün Boyutları',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: AppText(
                                              text: 'Yeni Ekle',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.plus,
                                            color: AppTheme.textColor,
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizeOfElement(
                                    productSizeList: _products!.sizeLists!,
                                  )
                                ],
                              ),
                            ),
                            AnaliticsOfProduct(
                              updatePage: widget.updatePage!,
                            ),
                            randomProducts!.isNotEmpty
                                ? Column(
                                    children: [
                                      Box_View(
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                AppLargeText(
                                                    text: 'Benzer Ürünler'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: paddingHorizontal,
                                            vertical: paddingHorizontal * .5),
                                        child: GridView.builder(
                                          padding: paddingZero,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing:
                                                      paddingHorizontal,
                                                  crossAxisSpacing:
                                                      paddingHorizontal,
                                                  childAspectRatio: 1.5),
                                          itemCount: randomProducts!.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _products =
                                                      randomProducts![index];
                                                  _scrollController.jumpTo(0);
                                                });
                                              },
                                              child: SimularProducts(
                                                simular: randomProducts![index],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
              AnimatedBuilder(
                animation: headerAnimation!,
                builder: (BuildContext context, Widget? child) {
                  return HeaderWidget(
                    blurOpacity: headerAnimation!.value,
                    headerColor: AppTheme.background1
                        .withOpacity(headerAnimation!.value),
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

class AnaliticsOfProduct extends StatefulWidget {
  const AnaliticsOfProduct({
    super.key,
    required this.updatePage,
  });
  final Function updatePage;
  @override
  State<AnaliticsOfProduct> createState() => _AnaliticsOfProductState();
}

class _AnaliticsOfProductState extends State<AnaliticsOfProduct> {
  List<String> _titles = [
    'Genel Analiz',
    'Ürünlerin Giriş Çıkış Verileri',
    'Ürünlerin Kar Maaliyeti',
    'Son Siparişler',
  ];

  void checkerOf(int pageIdSended, BuildContext context, bool checker) {
    if (checker) {
      widget.updatePage(pageId: pageIdSended);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Ürün Analizi',
                fontWeight: FontWeight.bold,
              ),
              Shop.selectedShop!.shopPermissions.shop_can_see_analytics
                  ? Container(
                      child: AppText(
                        text: '24 Saat',
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container()
            ],
          ),
          Shop.selectedShop!.shopPermissions.shop_can_see_analytics
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: paddingHorizontal),
                      child: GridView.count(
                        shrinkWrap: true,
                        padding: paddingZero,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: paddingHorizontal,
                        childAspectRatio: 1.5,
                        mainAxisSpacing: paddingHorizontal,
                        crossAxisCount: 2,
                        children: <Widget>[
                          FastProcess(
                            containerFunction: () {},
                            containerName: '111',
                            containerSubText: 'Giren Ürün Sayısı',
                            containerIconData: FontAwesomeIcons.plus,
                          ),
                          FastProcess(
                            containerFunction: () {},
                            containerName: Shop.selectedShop!.shopPermissions
                                    .shop_can_initilize_low_stok
                                ? '242'
                                : 'Kilitli',
                            containerSubText: 'Çıkan Ürün Sayısı',
                            containerIconData: FontAwesomeIcons.minus,
                          ),
                          FastProcess(
                            containerFunction: () {},
                            containerName: Shop.selectedShop!.shopPermissions
                                    .shop_can_initilize_low_stok
                                ? '${Product.doneStockProducts().length} Ürün'
                                : 'Kilitli',
                            containerSubText: 'Stokta Olmayan',
                            containerIconData: FontAwesomeIcons.a,
                          ),
                          FastProcess(
                            containerFunction: () {},
                            containerName: Shop.selectedShop!.shopPermissions
                                    .shop_can_init_reminder
                                ? '4 Ürün'
                                : 'Kilitli',
                            containerSubText: 'Hatırlatma',
                            containerIconData: FontAwesomeIcons.clock,
                          ),
                        ],
                      ),
                    ),

                    Box_View(
                      horizontal: 0,
                      color: AppTheme.background,
                      boxInside: Container(
                        width: double.maxFinite,
                        child: AppText(
                          text: 'Ürünlerin Giriş Çıkış Verileri',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //TODO grafiksel gösterim
                    Box_View(
                      horizontal: 0,
                      color: AppTheme.background,
                      boxInside: Container(
                        width: double.maxFinite,
                        child: AppText(
                          text: 'Ürünlerin Kar-Maliyet Tablosu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //TODO grafiksel gösterim
                    Box_View(
                      horizontal: 0,
                      color: AppTheme.background,
                      boxInside: Container(
                        width: double.maxFinite,
                        child: AppText(
                          text: 'Son Siparişler',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //TODO aşşağı sırala
                  ],
                )
              : Container(
                  padding: EdgeInsets.all(paddingHorizontal),
                  alignment: Alignment.center,
                  child: AppLargeText(
                    text:
                        'İşletmenizin Ürün Analizlerini Görmeye Yetkisi Yoktur. Paketinizi Genişleterek Görüntüleyebilirsiniz',
                    maxLineCount: 5,
                    align: TextAlign.center,
                  ),
                )
        ],
      ),
    );
  }
}

/* 
TODO Ürün Analizleri: 
  *dashboard
  *Ürünlerin Giriş Çıkış Verileri
  *Ürünlerin Kar Maaliyeti
  *Son Siparişler
 */
class SizeOfElement extends StatefulWidget {
  const SizeOfElement({
    super.key,
    required this.productSizeList,
  });
  final List<SizeList> productSizeList;

  @override
  State<SizeOfElement> createState() => _SizeOfElementState();
}

class _SizeOfElementState extends State<SizeOfElement> {
  int selectedIndex = 0;
  SizeList? selectedSizelist;
  @override
  void initState() {
    setState(() {
      selectedSizelist = widget.productSizeList.first;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        widget.productSizeList.length == 1
            ? Container()
            : Container(
                height: 20,
                child: ListView.builder(
                  itemCount: widget.productSizeList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          selectedSizelist = widget.productSizeList[index];
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: paddingHorizontal),
                        decoration: BoxDecoration(
                            border: selectedIndex == index
                                ? Border(
                                    bottom: BorderSide(
                                        color: AppTheme.contrastColor1),
                                  )
                                : null),
                        child: AppText(
                            text: widget.productSizeList[index].nameOfSize!),
                      ),
                    );
                  },
                ),
              ),
        Box_View(
          color: AppTheme.background,
          horizontal: 0,
          boxInside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.productSizeList.length == 1
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                      child: AppText(
                        text:
                            'Ürünün Boyut İsimi : ${selectedSizelist!.nameOfSize}',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                child: AppText(
                  text: 'Ürünün Stok Kodu : ${selectedSizelist!.stockCode}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                child: AppText(
                  text:
                      'Ürünün Boyutları : ${selectedSizelist!.dimensionalWeight}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                child: AppText(
                  text:
                      'Ürünün Uyarı Verilecek Stok Sayısı : ${selectedSizelist!.alertLowStock}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                child: AppText(
                  text:
                      'Ürünün Şuanki Stok Sayısı : ${selectedSizelist!.quantity}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: paddingHorizontal / 2),
                child: AppText(
                  text:
                      'Ürünün Alış Fiyatı : ${selectedSizelist!.listPrice} ${selectedSizelist!.listPriceCurrency}',
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppText(
                text:
                    'Ürünün Satış Fiyatı : ${selectedSizelist!.salePrice} ${selectedSizelist!.salePriceCurency}',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
