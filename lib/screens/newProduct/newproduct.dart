// ignore_for_file: unused_field

import 'dart:io';
import 'dart:ui';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/newProduct/component/shopProductAdding/enterence.dart';
import 'package:envanterimservetim/screens/newProduct/component/shopProductAdding/productCategories.dart';
import 'package:envanterimservetim/screens/newProduct/component/shopProductAdding/select_image_from_phone.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class NewShopProductPage extends StatefulWidget {
  const NewShopProductPage(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey,
      required this.barkod})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;
  final String barkod;

  @override
  _NewShopProductPageState createState() => _NewShopProductPageState();
}

class _NewShopProductPageState extends State<NewShopProductPage>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation,
      filterOpacity,
      filterTransform,
      headerAnimation;
  AnimationController? filterAnimation, headerAnimationController;

  Color iconColor = AppTheme.textColor;
  double topBarOpacity = 0.0, searchBarOpacity = .6;
  ParaBirimi currency_sell = ParaBirimi.paraBirimleri[0],
      currency_buy = ParaBirimi.paraBirimleri[1];
  TextEditingController _sizeNameController = TextEditingController(),
      _sizeStockCodeController = TextEditingController(),
      _esizeStockController = TextEditingController(),
      _sizeAlertController = TextEditingController(),
      _editingController = TextEditingController(),
      _sizeDimensionsController = TextEditingController(),
      _sizeListController = TextEditingController(),
      _sizeSaleController = TextEditingController();
  Widget tabBody = Container();
  PageController _pageController = PageController();

  List<File> _selectedImages = [];
  List<SizeList> _listOfSizeList = [];
  Categories? selectedCategories = null;
  String sizeName = '',
      sizeStockCode = '',
      sizeStock = '',
      sizeAlert = '',
      sizeDimensions = '',
      sizeList = '',
      sizeListCur = '',
      sizeSaleCur = '',
      sizeSale = '';

  bool tekli = false, isFetch = false, isError = false;

  Product _newProduct = Product();

  @override
  void initState() {
    setState(() {
      if (widget.barkod != '') {
        _editingController.text = widget.barkod;
        _newProduct.barcode = widget.barkod;
      }
    });
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
  }

  //TODO check avaliability of numbers
  void clearAllLines() {
    setState(() {
      sizeName = '';
      sizeStockCode = '';
      sizeStock = '';
      sizeAlert = '';
      sizeDimensions = '';
      sizeList = '';
      sizeListCur = '';
      sizeSaleCur = '';
      sizeSale = '';

      _sizeNameController.text = '';
      _sizeStockCodeController.text = '';
      _esizeStockController.text = '';
      _sizeAlertController.text = '';
      _editingController.text = '';
      _sizeDimensionsController.text = '';
      _sizeListController.text = '';
      _sizeSaleController.text = '';
    });
  }

  void createMultipleSizeListForContent() {
    SizeList createdSizelist = SizeList.createNewSizeList(
      name: sizeName,
      stock: int.parse(sizeStock),
      stockCodes: sizeStockCode,
      dimensionalWeights: sizeDimensions,
      listPrices: double.parse(sizeList.replaceAll(",", ".")),
      alertLowStock: sizeAlert != '' ? int.parse(sizeAlert) : -1,
      listPriceCurrencys: currency_buy.kod,
      salePrices: double.parse(sizeSale.replaceAll(",", ".")),
      salePriceCurencys: currency_sell.kod,
    );
    _listOfSizeList.add(createdSizelist);
    clearAllLines();
  }

  Future<void> createProductOnDatabase() async {
    setState(() {
      isFetch = !isFetch;
    });
    bool isOkay =
        await Product.uploadProductToDatabase(_newProduct, _selectedImages);
    setState(() {
      isFetch = !isFetch;
      if (isOkay) {
        widget.updatePage!(pageId: 0);
      } else {
        isError = true;
      }
    });
  }

  Future<void> scanNormalBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.BARCODE, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      setState(() {
        _editingController.text = barcodeScanResult;
        _newProduct.barcode = barcodeScanResult;
      });
    }
    Navigator.pop(context);
  }

  Future<void> scanQRBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.QR, // Sadece barkodları tara
    );

    if (barcodeScanResult != '-1') {
      setState(() {
        _editingController.text = barcodeScanResult;
        _newProduct.barcode = barcodeScanResult;
      });
    }
    Navigator.pop(context);
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
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
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
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        width: double.maxFinite,
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListView(
                              padding: paddingZero,
                              shrinkWrap: true,
                              children: [
                                const ShopProductEnterence(),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'Barkod',
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 9,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 15),
                                              child: CustomTextfield(
                                                controller: _editingController,
                                                hintText: 'Ürünün Barkodu',
                                                onChange: (news) {
                                                  setState(() {
                                                    _newProduct.barcode = news;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (builder) {
                                                    return Container(
                                                      color:
                                                          AppTheme.background1,
                                                      padding: EdgeInsets.only(
                                                          bottom:
                                                              paddingHorizontal),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      paddingHorizontal),
                                                              child: AppText(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  text:
                                                                      'Ürününüzün Barkodunu Nasıl Eklemek İstersiniz?')),
                                                          GestureDetector(
                                                            onTap:
                                                                scanNormalBarcode,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      paddingHorizontal),
                                                              child: Row(
                                                                children: [
                                                                  FaIcon(
                                                                      FontAwesomeIcons
                                                                          .camera,
                                                                      color: AppTheme
                                                                          .textColor),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                paddingHorizontal),
                                                                    child: AppText(
                                                                        text:
                                                                            'Normal Barkod Tara'),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap:
                                                                scanQRBarcode,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      paddingHorizontal),
                                                              child: Row(
                                                                children: [
                                                                  FaIcon(
                                                                      FontAwesomeIcons
                                                                          .qrcode,
                                                                      color: AppTheme
                                                                          .textColor),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                paddingHorizontal),
                                                                    child: AppText(
                                                                        text:
                                                                            'QR Kod Tara'),
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
                                              },
                                              child: FaIcon(
                                                FontAwesomeIcons.camera,
                                                color: AppTheme.textColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'Ürün İsimi',
                                      ),
                                      Container(
                                        child: CustomTextfield(
                                          hintText: 'Ürünün İsimi',
                                          onChange: (news) {
                                            setState(() {
                                              _newProduct.title = news;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ProductCategories(
                                  selectOne: (Categories categories) {
                                    setState(() {
                                      selectedCategories = categories;
                                      _newProduct.category = categories;
                                    });
                                  },
                                ),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: paddingHorizontal),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppLargeText(text: 'Ürünün Boyutu'),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  tekli = !tekli;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    paddingHorizontal / 2),
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppTheme.contrastColor1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            paddingHorizontal)),
                                                child: AppText(
                                                    text: tekli
                                                        ? 'Çoklu Boyut'
                                                        : 'Tek Boyut', color: Colors.white,),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: paddingHorizontal),
                                        child: AppText(
                                          text:
                                              'Envanter paketine sahip olduğunuz için, isterseniz aynı ürünün farklı boyutlarını oluşturabilirsiniz. Bu özellik, işletmenizin stok yönetimini daha esnek ve etkili bir şekilde yapmanıza olanak tanır. ',
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: paddingHorizontal),
                                        child: AppText(
                                          text:
                                              'Modu değiştirmek için sağ üste tıklayarak değiştirebilirsiniz!',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      tekli
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _listOfSizeList.isNotEmpty
                                                    ? Box_View(
                                                        horizontal: 0,
                                                        color:
                                                            AppTheme.background,
                                                        boxInside: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .maxFinite,
                                                              child: AppText(
                                                                text:
                                                                    'Eklediğiniz Boyutlar',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top:
                                                                          paddingHorizontal),
                                                              height: 35,
                                                              child: ListView
                                                                  .builder(
                                                                itemCount:
                                                                    _listOfSizeList
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                padding:
                                                                    paddingZero,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                        color: AppTheme
                                                                            .contrastColor1,
                                                                        borderRadius:
                                                                            defaultRadius),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            paddingHorizontal),
                                                                    child: AppText(
                                                                        text:
                                                                            '${_listOfSizeList[index].nameOfSize}'),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ))
                                                    : Container(),
                                                Box_View(
                                                  horizontal: 0,
                                                  color: AppTheme.background,
                                                  boxInside: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text: 'Boyutun İsmi',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: CustomTextfield(
                                                          controller:
                                                              _sizeNameController,
                                                          hintText:
                                                              'Boyutun İsmi',
                                                          onChange: (news) {
                                                            setState(() {
                                                              sizeName = news;
                                                            });
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text: 'Ürün Stok Kodu',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: CustomTextfield(
                                                          controller:
                                                              _sizeStockCodeController,
                                                          hintText:
                                                              'Ürünün Stok Kodu',
                                                          onChange: (news) {
                                                            print(
                                                                sizeStockCode);
                                                            setState(() {
                                                              sizeStockCode =
                                                                  news;
                                                            });
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text: 'Stok Sayısı',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: CustomTextfield(
                                                          controller:
                                                              _esizeStockController,
                                                          hintText:
                                                              'Ürünün Stok Sayısı',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChange: (news) {
                                                            setState(() {
                                                              sizeStock = news;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Shop
                                                        .selectedShop!
                                                        .shopPermissions
                                                        .shop_can_initilize_low_stok
                                                    ? Box_View(
                                                        horizontal: 0,
                                                        color:
                                                            AppTheme.background,
                                                        boxInside: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            AppText(
                                                              text:
                                                                  'Uyarı Vermesini İstediğin Stok Sayısı',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            Container(
                                                              child:
                                                                  CustomTextfield(
                                                                controller:
                                                                    _sizeAlertController,
                                                                hintText:
                                                                    'Ürünün Uyarı Vermesini İstediğin Stok Sayısı',
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                onChange:
                                                                    (news) {
                                                                  setState(() {
                                                                    sizeAlert =
                                                                        news;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container(),
                                                Box_View(
                                                  horizontal: 0,
                                                  color: AppTheme.background,
                                                  boxInside: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            'Ürünün Boyutları',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: CustomTextfield(
                                                          controller:
                                                              _sizeDimensionsController,
                                                          hintText:
                                                              'Ürünün Boyutları',
                                                          onChange: (news) {
                                                            setState(() {
                                                              sizeDimensions =
                                                                  news;
                                                            });
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text: 'Ürün Maliyeti',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                child:
                                                                    CustomTextfield(
                                                                  controller:
                                                                      _sizeListController,
                                                                  hintText:
                                                                      'Ürünün Maliyeti',
                                                                  keyboardType:
                                                                      TextInputType.numberWithOptions(
                                                                          decimal:
                                                                              true),
                                                                  inputFormatters: <TextInputFormatter>[
                                                                    FilteringTextInputFormatter
                                                                        .allow(RegExp(
                                                                            r'^(\d+)?\.?\d{0,2}'))
                                                                  ],
                                                                  onChange:
                                                                      (news) {
                                                                    setState(
                                                                        () {
                                                                      sizeList =
                                                                          news;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return Product_Currency(
                                                                        title:
                                                                            'Ürünün Satış Fiyatı Birimi',
                                                                        selectedParaBirimi:
                                                                            currency_buy,
                                                                        onSelect:
                                                                            (ParaBirimi
                                                                                index) {
                                                                          setState(
                                                                              () {
                                                                            currency_buy =
                                                                                index;
                                                                            sizeListCur =
                                                                                index.kod;
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              15),
                                                                  decoration: BoxDecoration(
                                                                      color: AppTheme
                                                                          .firstColor
                                                                          .withOpacity(
                                                                              .3)),
                                                                  child: AppText(
                                                                      text: currency_buy
                                                                          .kod),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Box_View(
                                                  horizontal: 0,
                                                  color: AppTheme.background,
                                                  boxInside: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            'Ürün Satış Fiyatı',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 8,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                child:
                                                                    CustomTextfield(
                                                                  controller:
                                                                      _sizeSaleController,
                                                                  hintText:
                                                                      'Ürünün Satış Fiyatı',
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .numberWithOptions(
                                                                    decimal:
                                                                        true,
                                                                  ),
                                                                  inputFormatters: <TextInputFormatter>[
                                                                    FilteringTextInputFormatter
                                                                        .allow(RegExp(
                                                                            r'^(\d+)?\.?\d{0,2}'))
                                                                  ],
                                                                  onChange:
                                                                      (news) {
                                                                    setState(
                                                                        () {
                                                                      sizeSale =
                                                                          news;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (ctx) {
                                                                      return Product_Currency(
                                                                        title:
                                                                            'Ürünün Satış Fiyatı Birimi',
                                                                        selectedParaBirimi:
                                                                            currency_sell,
                                                                        onSelect:
                                                                            (ParaBirimi
                                                                                index) {
                                                                          setState(
                                                                              () {
                                                                            currency_sell =
                                                                                index;
                                                                            sizeSaleCur =
                                                                                index.kod;
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              15),
                                                                  decoration: BoxDecoration(
                                                                      color: AppTheme
                                                                          .firstColor
                                                                          .withOpacity(
                                                                              .3)),
                                                                  child: AppText(
                                                                      text: currency_sell
                                                                          .kod),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap:
                                                      createMultipleSizeListForContent,
                                                  child: Box_View(
                                                    horizontal: 0,
                                                    color:
                                                        AppTheme.contrastColor1.withOpacity(.6),
                                                    boxInside: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AppText(
                                                          text:
                                                              'Yeni Boyut Olarak Ekle',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        FaIcon(
                                                          FontAwesomeIcons.plus,
                                                          color: AppTheme
                                                              .textColor,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                'Ürün Stok Kodu',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          Container(
                                                            child:
                                                                CustomTextfield(
                                                              controller:
                                                                  _sizeStockCodeController,
                                                              hintText:
                                                                  'Ürünün Stok Kodu',
                                                              onChange: (news) {
                                                                print(
                                                                    sizeStockCode);
                                                                setState(() {
                                                                  sizeStockCode =
                                                                      news;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text: 'Stok Sayısı',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          Container(
                                                            child:
                                                                CustomTextfield(
                                                              controller:
                                                                  _esizeStockController,
                                                              hintText:
                                                                  'Ürünün Stok Sayısı',
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              onChange: (news) {
                                                                setState(() {
                                                                  sizeStock =
                                                                      news;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Shop
                                                            .selectedShop!
                                                            .shopPermissions
                                                            .shop_can_initilize_low_stok
                                                        ? Box_View(
                                                            horizontal: 0,
                                                            color: AppTheme
                                                                .background,
                                                            boxInside: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                AppText(
                                                                  text:
                                                                      'Uyarı Vermesini İstediğin Stok Sayısı',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                /* int.parse(sizeAlert) >
                                                                        int.parse(
                                                                            sizeStock)
                                                                    ? Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: paddingHorizontal / 2),
                                                                        child:
                                                                            AppText(
                                                                          text:
                                                                              'Uyarı verilecek stok değeri normal stok değerinden yüksek olamaz.',
                                                                          color:
                                                                              AppTheme.alertRed[0],
                                                                        ),
                                                                      )
                                                                    : Container(), */
                                                                Container(
                                                                  child:
                                                                      CustomTextfield(
                                                                    controller:
                                                                        _sizeAlertController,
                                                                    hintText:
                                                                        'Ürünün Uyarı Vermesini İstediğin Stok Sayısı',
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    onChange:
                                                                        (news) {
                                                                      setState(
                                                                          () {
                                                                        sizeAlert =
                                                                            news;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Container(),
                                                    Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                'Ürünün Boyutları',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          Container(
                                                            child:
                                                                CustomTextfield(
                                                              controller:
                                                                  _sizeDimensionsController,
                                                              hintText:
                                                                  'Ürünün Boyutları',
                                                              onChange: (news) {
                                                                setState(() {
                                                                  sizeDimensions =
                                                                      news;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                'Ürün Maliyeti',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 8,
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                    child:
                                                                        CustomTextfield(
                                                                      controller:
                                                                          _sizeListController,
                                                                      hintText:
                                                                          'Ürünün Maliyeti',
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .numberWithOptions(
                                                                        decimal:
                                                                            true,
                                                                      ),
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                                                                      ],
                                                                      onChange:
                                                                          (news) {
                                                                        setState(
                                                                            () {
                                                                          sizeList =
                                                                              news;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (ctx) {
                                                                          return Product_Currency(
                                                                            title:
                                                                                'Ürünün Satış Fiyatı Birimi',
                                                                            selectedParaBirimi:
                                                                                currency_buy,
                                                                            onSelect:
                                                                                (ParaBirimi index) {
                                                                              setState(() {
                                                                                currency_buy = index;
                                                                                sizeListCur = index.kod;
                                                                              });

                                                                              Navigator.pop(context);
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: AppTheme
                                                                              .firstColor
                                                                              .withOpacity(.3)),
                                                                      child: AppText(
                                                                          text:
                                                                              currency_buy.kod),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                'Ürün Satış Fiyatı',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 8,
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                    child:
                                                                        CustomTextfield(
                                                                      controller:
                                                                          _sizeSaleController,
                                                                      hintText:
                                                                          'Ürünün Satış Fiyatı',
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .numberWithOptions(
                                                                        decimal:
                                                                            true,
                                                                      ),
                                                                      inputFormatters: <TextInputFormatter>[
                                                                        FilteringTextInputFormatter.allow(
                                                                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                                                                      ],
                                                                      onChange:
                                                                          (news) {
                                                                        setState(
                                                                            () {
                                                                          sizeSale =
                                                                              news;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                        isScrollControlled:
                                                                            true,
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (ctx) {
                                                                          return Product_Currency(
                                                                            title:
                                                                                'Ürünün Satış Fiyatı Birimi',
                                                                            selectedParaBirimi:
                                                                                currency_sell,
                                                                            onSelect:
                                                                                (ParaBirimi index) {
                                                                              setState(() {
                                                                                currency_sell = index;
                                                                                sizeSaleCur = index.kod;
                                                                              });

                                                                              Navigator.pop(context);
                                                                            },
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: AppTheme
                                                                              .firstColor
                                                                              .withOpacity(.3)),
                                                                      child: AppText(
                                                                          text:
                                                                              currency_sell.kod),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'Vergi Oranı %',
                                      ),
                                      Container(
                                        child: CustomTextfield(
                                          hintText: 'Ürünün Vergi Oranı',
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^(\d+)?\.?\d{0,2}'))
                                          ],
                                          onChange: (news) {
                                            setState(() {
                                              _newProduct.vatRate = news;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(sizeStockCode);
                                    if (sizeStockCode != '') {
                                      print('object');
                                      createMultipleSizeListForContent();
                                    }
                                    setState(() {
                                      _newProduct.sizeLists = _listOfSizeList;
                                    });
                                    print(_newProduct.sizeLists!.length);
                                    _pageController.nextPage(
                                        duration: defaultDuration,
                                        curve: Curves.easeInOut);
                                  },
                                  child: Box_View(
                                    color: AppTheme.contrastColor1.withOpacity(.6),
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Devam Et',
                                          fontWeight: FontWeight.bold,
                                          
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.arrowRight,
                                          color: AppTheme.textColor
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              padding: paddingZero,
                              children: [
                                ShopEnterenceSecond(),
                                Box_View(
                                  boxInside: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: paddingHorizontal),
                                        child: AppLargeText(
                                          text: 'Ürünün Açıklaması',
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.all(paddingHorizontal),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.textColor
                                                    .withOpacity(.3))),
                                        child: CustomTextfield(
                                          hintText: 'Ürünün Açıklaması',
                                          onChange: (String str) {
                                            _newProduct.description = str;
                                          },
                                          maxLineCount: 5,
                                          borderAvaliable: false,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Box_View(
                                  boxInside: ImagePickerAndUploaderWidget(
                                    selectImagesFunction: (List<File> images) {
                                      setState(() {
                                        _selectedImages = images;
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _pageController.nextPage(
                                        duration: defaultDuration,
                                        curve: Curves.easeInOut);
                                  },
                                  child: Box_View(
                                    color: AppTheme.contrastColor1,
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppLargeText(
                                          text: 'Devam Et',
                                          color: Colors.white,
                                        ),
                                        FaIcon(
                                          FontAwesomeIcons.arrowRight,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ListView(
                              shrinkWrap: true,
                              padding: paddingZero,
                              children: [
                                ProductReview(
                                  newProduct: _newProduct,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isFetch = !isFetch;
                                    });
                                  },
                                  child: Box_View(
                                    boxInside: AppText(text: 'Reset'),
                                  ),
                                ),
                                isError
                                    ? Box_View(
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.warning,
                                                  color: AppTheme.alertRed[0],
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            paddingHorizontal),
                                                    child: AppLargeText(
                                                      text:
                                                          'Bir şeyler ters gitti! Lütfen daha sonra tekrar deneyiniz',
                                                      color:
                                                          AppTheme.alertRed[0],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                isFetch
                                    ? Center(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: createProductOnDatabase,
                                        child: Box_View(
                                          color: AppTheme.contrastColor1,
                                          boxInside: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AppLargeText(
                                                text: 'Devam Et',
                                                color: Colors.white,
                                              ),
                                              FaIcon(
                                                FontAwesomeIcons.arrowRight,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                              ],
                            )
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
                    headerColor:
                        AppTheme.background.withOpacity(headerAnimation!.value),
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

class ProductReview extends StatefulWidget {
  const ProductReview({
    super.key,
    required Product newProduct,
  }) : _newProduct = newProduct;

  final Product _newProduct;

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  SizeList? selectedSizeList;
  @override
  void initState() {
    setState(() {
      selectedSizeList = widget._newProduct.sizeLists![0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: paddingZero,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Box_View(
          boxInside: AppLargeText(
            text: 'Ürününüzü Gözden Geçirin',
            fontWeight: FontWeight.w600,
          ),
        ),
        Box_View(
          boxInside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: AppLargeText(text: 'Ürünün Ana Özellikleri'),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Barkodu'),
                    AppText(text: '${widget._newProduct.barcode}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün İsimi'),
                    AppText(text: '${widget._newProduct.title}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Açıklaması'),
                    AppText(text: '${widget._newProduct.description}')
                  ],
                ),
              ),
            ],
          ),
        ),
        Box_View(
          boxInside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: AppLargeText(text: 'Ürünün Boyut Bilgileri'),
              ),
              widget._newProduct.sizeLists!.length > 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: paddingHorizontal),
                          height: 35,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: paddingZero,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget._newProduct.sizeLists!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedSizeList =
                                        widget._newProduct.sizeLists![index];
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: paddingHorizontal),
                                  margin:
                                      EdgeInsets.only(right: paddingHorizontal),
                                  decoration: BoxDecoration(
                                      color: widget._newProduct
                                                  .sizeLists![index] ==
                                              selectedSizeList
                                          ? AppTheme.contrastColor1
                                          : null,
                                      border: Border.all(
                                          color: AppTheme.contrastColor1),
                                      borderRadius: BorderRadius.circular(
                                          paddingHorizontal)),
                                  child: AppText(
                                    text:
                                        '${widget._newProduct.sizeLists![index].nameOfSize}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: paddingHorizontal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: 'Ürünün İsimi'),
                              AppText(text: '${selectedSizeList!.nameOfSize}')
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Boyutun Stok Kodu'),
                    AppText(text: '${selectedSizeList!.stockCode}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Stok Sayısı'),
                    AppText(text: '${selectedSizeList!.quantity}')
                  ],
                ),
              ),
              Shop.selectedShop!.shopPermissions.shop_can_initilize_low_stok
                  ? Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(text: 'Ürünün Uyarı Verilecek Stok'),
                          AppText(text: '${selectedSizeList!.alertLowStock}')
                        ],
                      ),
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Boyutlar'),
                    AppText(text: '${selectedSizeList!.dimensionalWeight}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Maliyeti'),
                    AppText(text: '${selectedSizeList!.listPrice}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Maliyet Birimi'),
                    AppText(text: '${selectedSizeList!.listPriceCurrency}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Satış Fiyatı'),
                    AppText(text: '${selectedSizeList!.salePrice}')
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: paddingHorizontal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Ürünün Satış Birimi'),
                    AppText(text: '${selectedSizeList!.salePriceCurency}')
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable, camel_case_types
class Product_Currency extends StatelessWidget {
  Product_Currency({
    super.key,
    required this.onSelect,
    required this.title,
    this.selectedParaBirimi,
  });

  final Function onSelect;
  final String title;
  final ParaBirimi? selectedParaBirimi;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .8,
      maxChildSize: .9,
      builder: (_, controller) {
        return Container(
          color: AppTheme.background,
          width: double.maxFinite,
          child: ListView(
            controller: controller,
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.all(
                  paddingHorizontal,
                ),
                child: AppLargeText(text: title),
              ),
              Container(
                padding: EdgeInsets.all(
                  paddingHorizontal,
                ),
                child: AppText(
                  text:
                      'Aşağıdaki birimlerden birisini seçerek ürününüzün birimini belirleyebilirsiniz, böylece siparişlerinizi daha etkili ve düzenli bir şekilde yönetebilirsiniz. Seçilen birim, ürün fiyatlandırması, stok takibi ve diğer işlemler için temel bir referans noktası olacaktır. Doğru bir birim seçimi, iş süreçlerinizi optimize etmenize ve müşterilerinize daha iyi hizmet sunmanıza yardımcı olacaktır',
                  maxLineCount: 10,
                ),
              ),
              ListView.builder(
                itemCount: ParaBirimi.paraBirimleri.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      onSelect(ParaBirimi.paraBirimleri[index]);
                    },
                    child: Box_View(
                      color:
                          ParaBirimi.paraBirimleri[index] == selectedParaBirimi
                              ? AppTheme.contrastColor1
                              : null,
                      boxInside: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              AppText(
                                text: ParaBirimi.paraBirimleri[index].ad,
                                fontWeight: FontWeight.bold,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: paddingHorizontal),
                                child: AppText(
                                  text:
                                      '(${ParaBirimi.paraBirimleri[index].kod})',
                                ),
                              ),
                            ],
                          ),
                          ParaBirimi.paraBirimleri[index] == selectedParaBirimi
                              ? FaIcon(
                                  FontAwesomeIcons.check,
                                  color: AppTheme.textColor,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
