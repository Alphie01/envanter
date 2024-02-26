import 'dart:io';
import 'dart:ui';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/stockspage/components/gestureCatagoryModal.dart';
import 'package:envanterimservetim/screens/stockspage/components/stockErrors.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:envanterimservetim/widgets/refresh_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class StockPage extends StatefulWidget {
  const StockPage(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation,
      filterOpacity,
      filterTransform,
      headerAnimation;
  AnimationController? filterAnimation, headerAnimationController;
  ScrollController _scrollController = ScrollController();
  Color iconColor = AppTheme.textColor;
  double topBarOpacity = 0.0, searchBarOpacity = .6, offset = 0;
  Socket? socket;
  int selectedCategory = -1;
  bool showError = false, refreshContainerData = false, showAllProducts = false;
  List<Product> _products = [];
  @override
  void initState() {
    /* connectServer(); */
    setState(() {
      _products = Product.products;
      showError = Product.isThereAnyWarning();
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
      setState(() {
        offset = _scrollController.offset;
      });
    });
    super.initState();
    widget.animationController!.forward();
  }

  void refreshData() {
    setState(() {
      refreshContainerData = !refreshContainerData;
    });
    Future.delayed(defaultDuration, () {
      setState(() {
        refreshContainerData = !refreshContainerData;
      });
    });
  }

  Future _deleteCategories(Categories deleted) async {
    bool dance = await Categories.deleteCategories(deleted);
    if (dance) {
      refreshData();
    }
  }

  void _showAlertDialogDeleteCategories(
      BuildContext context, Categories categories) {
    if (Shop.selectedShop!.userPermissionLevel != 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppTheme.background,
            title: AppLargeText(
                text:
                    'Uyarı! Seçmiş Olduğunuz Kategoriyi Silmek İstediğinizden Emin Misiniz?'),
            content: AppText(
              text:
                  'Seçmiş olduğunuz ${categories.name} isimli kategoriyi silmek istediğinizden emin misiniz? Silerseniz bu kategoride eklediğiniz ürünler boşa çıkacaktır ve tekrar kategori belirlemeniz gerekecektir.',
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
                  _deleteCategories(categories);
                  Navigator.of(context).pop();
                },
                child: AppText(
                  text: 'Sil',
                  color: AppTheme.alertRed[0],
                ),
              ),
            ],
          );
        },
      );
    }
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
                        margin: EdgeInsets.only(
                            top: getPaddingScreenTopHeight() +
                                AppBar().preferredSize.height),
                        width: double.maxFinite,
                        child: ListView(
                          controller: _scrollController,
                          padding: paddingZero,
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: paddingHorizontal,
                            ),
                            showError
                                ? ProductErrors(
                                    showErrorSet: () {
                                      setState(() {
                                        showError = !showError;
                                      });
                                    },
                                  )
                                : Container(),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: AppLargeText(
                                            text: 'Kategoriler',
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (builder) {
                                                return GestureCategoriesModal();
                                              },
                                            );
                                            refreshData();
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        paddingHorizontal / 2),
                                                child: AppLargeText(
                                                  text: 'Yeni Ekle',
                                                ),
                                              ),
                                              FaIcon(
                                                FontAwesomeIcons.plus,
                                                size: 14,
                                                color: AppTheme.textColor,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'Bu kısımda, ürünlerinizin sergileneceği ve müşterilerinizin ürünlerini hangi kategorilerde göreceğini bulabilirsiniz.',
                                    ),
                                  ),
                                  refreshContainerData
                                      ? Container()
                                      : Categories.menuTypeIsEmpty()
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: paddingHorizontal),
                                              child: AppText(
                                                text:
                                                    'Daha Önceden Ürünleriniz İçin Kategori Eklememişsiniz!',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: paddingZero,
                                              itemCount: Categories
                                                      .returnMainCategoriess()
                                                  .length,
                                              itemBuilder: (ctx, index) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.maxFinite,
                                                      margin: EdgeInsets.only(
                                                          bottom:
                                                              paddingHorizontal /
                                                                  2),
                                                      padding: EdgeInsets.all(
                                                          paddingHorizontal),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme
                                                              .contrastColor1,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  paddingHorizontal)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AppText(
                                                            text: Categories
                                                                        .returnMainCategoriess()[
                                                                    index]
                                                                .name,
                                                            color: Colors.white,
                                                          ),
                                                          Categories.isThereSubMenu(
                                                                  Categories.returnMainCategoriess()[
                                                                          index]
                                                                      .menuTypeId)
                                                              ? Container()
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    _showAlertDialogDeleteCategories(
                                                                        context,
                                                                        Categories.returnMainCategoriess()[
                                                                            index]);
                                                                  },
                                                                  child: FaIcon(
                                                                    FontAwesomeIcons
                                                                        .trash,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    Categories.isThereSubMenu(
                                                            Categories.returnMainCategoriess()[
                                                                    index]
                                                                .menuTypeId)
                                                        ? ListView.builder(
                                                            itemCount: Categories.returnSubCategoriess(
                                                                    Categories.returnMainCategoriess()[
                                                                            index]
                                                                        .menuTypeId)
                                                                .length,
                                                            shrinkWrap: true,
                                                            padding:
                                                                paddingZero,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context, ind) {
                                                              return Container(
                                                                width: double
                                                                    .maxFinite,
                                                                margin: EdgeInsets.only(
                                                                    bottom:
                                                                        paddingHorizontal /
                                                                            2,
                                                                    left:
                                                                        paddingHorizontal),
                                                                padding:
                                                                    EdgeInsets.all(
                                                                        paddingHorizontal),
                                                                decoration: BoxDecoration(
                                                                    color: AppTheme
                                                                        .contrastColor3,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            paddingHorizontal)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    AppText(
                                                                      text: Categories.returnSubCategoriess(
                                                                              Categories.returnMainCategoriess()[index].menuTypeId)[ind]
                                                                          .name,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        _showAlertDialogDeleteCategories(
                                                                            context,
                                                                            Categories.returnSubCategoriess(Categories.returnMainCategoriess()[index].menuTypeId)[ind]);
                                                                      },
                                                                      child:
                                                                          FaIcon(
                                                                        FontAwesomeIcons
                                                                            .trash,
                                                                        color: AppTheme
                                                                            .textColor,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : Container()
                                                  ],
                                                );
                                              },
                                            ),
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
                                      GestureDetector(
                                        onTap: () {
                                          print(_products.length);
                                        },
                                        child: Container(
                                          child: AppLargeText(
                                            text: 'Ürünlerim',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: paddingHorizontal),
                                    height: 25,
                                    child: ListView(
                                      padding: paddingZero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCategory = -1;
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: selectedCategory == -1
                                                ? BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          color: AppTheme
                                                              .contrastColor1),
                                                    ),
                                                  )
                                                : BoxDecoration(),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: paddingHorizontal),
                                            child: AppText(
                                                text:
                                                    'Tümü (${_products.length})'),
                                          ),
                                        ),
                                        ListView.builder(
                                          padding: paddingZero,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              Categories.returnMainCategoriess()
                                                  .length,
                                          itemBuilder: (typeCtx, typeInd) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = typeInd;
                                                });
                                              },
                                              child: Container(
                                                decoration:
                                                    selectedCategory == typeInd
                                                        ? BoxDecoration(
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                  color: AppTheme
                                                                      .contrastColor1),
                                                            ),
                                                          )
                                                        : BoxDecoration(),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: paddingHorizontal,
                                                ),
                                                child: AppText(
                                                  text:
                                                      '${Categories.returnMainCategoriess()[typeInd].name} ',
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Product.products.isNotEmpty
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: paddingHorizontal),
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                padding: paddingZero,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisSpacing:
                                                            paddingHorizontal /
                                                                2,
                                                        crossAxisSpacing:
                                                            paddingHorizontal /
                                                                2,
                                                        childAspectRatio: .75),
                                                itemCount: showAllProducts
                                                    ? _products.length
                                                    : _products.length > 10
                                                        ? 10
                                                        : _products.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Product
                                                          .setSelectedProduct(
                                                              _products[index]);
                                                      widget.updatePage!(
                                                          pageId: 11);
                                                    },
                                                    child:
                                                        ProductOrderContainer(
                                                      product: _products[index],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  showAllProducts = true;
                                                });
                                              },
                                              child: Container(
                                                width: double.maxFinite,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppTheme.contrastColor1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            paddingHorizontal)),
                                                child: AppText(
                                                  align: TextAlign.center,
                                                  fontWeight: FontWeight.bold,
                                                  text: 'Daha Fazlasına Gözat!',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Box_View(
                                          horizontal: 0,
                                          color: AppTheme.background,
                                          boxInside: Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.all(
                                                paddingHorizontal * 3),
                                            child: AppLargeText(
                                              text:
                                                  'Daha Hiç Ürün Eklenmemiştir.',
                                              align: TextAlign.center,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
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
              Refresh_widget(
                scrollOffset: offset,
                refreshPage: () {},
              ),
              AnimatedBuilder(
                animation: headerAnimation!,
                builder: (BuildContext context, Widget? child) {
                  return HeaderWidget(
                    blurOpacity: headerAnimation!.value,
                    headerColor: AppTheme.background1.withOpacity(1),
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

class ProductOrderContainer extends StatelessWidget {
  const ProductOrderContainer({
    super.key,
    required this.product,
  });

  final Product product;
  @override
  Widget build(BuildContext context) {
    return NetworkContainer(
      imageUrl: product.images!.length != 0
          ? product.images!.first
          : NetworkImage('https://dev.elektronikey.com/products/products.png'),
      child: Container(
        decoration: BoxDecoration(color: AppTheme.background.withOpacity(.6)),
        padding: EdgeInsets.all(paddingHorizontal),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLargeText(text: product.title!),
            AppText(text: '${product.barcode}'),
            App_Rich_Text(
              text: ['Ekleyen:', ' ${product.adderUserName}'],
              maxLineCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
