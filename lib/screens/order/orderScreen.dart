import 'dart:io';
import 'dart:ui';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/refresh_widget.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
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
    setState(() {});
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
                        width: double.maxFinite,
                        child: ListView(
                          controller: _scrollController,
                          padding: paddingZero,
                          shrinkWrap: true,
                          children: [
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AppLargeText(text: 'Sipariş Oluştur'),
                                    ],
                                  ),
                                  AppText(
                                      text:
                                          'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Dolore corrupti et sapiente possimus quidem eveniet similique aliquid laudantium quis natus officia expedita, maxime explicabo earum voluptatem enim ab doloribus sint.')
                                ],
                              ),
                            ),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargeText(text: 'Ara'),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: paddingHorizontal * .5),
                                    child: Box_View(
                                      horizontal: 0,
                                      vertical: 0,
                                      color: AppTheme.background,
                                      boxInside: Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextfield(
                                              hintText:
                                                  'Eklemek istediğiniz ürünün barkodu, anahtar kelimesi...',
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                paddingHorizontal * .7),
                                            decoration: BoxDecoration(
                                                color: AppTheme.contrastColor1
                                                    .withOpacity(.6),
                                                shape: BoxShape.circle),
                                            child: FaIcon(
                                              FontAwesomeIcons.barcode,
                                              color: AppTheme.textColor,
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AppLargeText(text: 'Tüm Ürünler'),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    child: Box_View(
                                      horizontal: 0,
                                      color: AppTheme.background,
                                      boxInside: ListView.builder(
                                        padding: paddingZero,
                                        itemCount: Product.products.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Product _product =
                                              Product.products[index];
                                          return OrderAllProducts(
                                            product: _product,
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppLargeText(text: 'Eklediğiniz Ürünler'),
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

class OrderAllProducts extends StatefulWidget {
  const OrderAllProducts({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  State<OrderAllProducts> createState() => _OrderAllProductsState();
}

class _OrderAllProductsState extends State<OrderAllProducts> {
  bool onTapped = false;
  int count = 0;
  void deleteProduct() {
    //TODO delete from all list
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      child: GestureDetector(
        onTap: () {
          if (!onTapped) {
            setState(() {
              onTapped = true;
              count = 1;
            });
          }
        },
        child: Box_View(
          horizontal: 0,
          vertical: 0,
          color: onTapped ? AppTheme.contrastColor1.withOpacity(.6) : null,
          boxInside: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(text: '${widget.product.title}'),
                  AppText(
                    text: 'Düzenle',
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class SubSizelist extends StatelessWidget {
  const SubSizelist({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}