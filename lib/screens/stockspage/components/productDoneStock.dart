import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDoneStock extends StatefulWidget {
  const ProductDoneStock(
      {super.key, required this.product, this.isNoneStock = false});
  final Product product;
  final bool isNoneStock;

  @override
  State<ProductDoneStock> createState() => _ProductDoneStockState();
}

class _ProductDoneStockState extends State<ProductDoneStock> {
  List<SizeList> _lowProducts = [], _doneProducts = [];
  bool isExpanded = false;

  void warnedSizeLists() {
    if (widget.product.sizeLists!.length > 1) {
      for (var sizes in widget.product.sizeLists!) {
        if (sizes.alertLowStock! >= sizes.quantity! && sizes.quantity! != 0) {
          _lowProducts.add(sizes);
        }
        if (sizes.quantity! == 0) {
          _doneProducts.add(sizes);
        }
      }
    } else {
      if (widget.product.sizeLists!.first.alertLowStock! >=
              widget.product.sizeLists!.first.quantity! &&
          widget.product.sizeLists!.first.quantity! != 0) {
        _lowProducts.add(widget.product.sizeLists!.first);
      }
      if (widget.product.sizeLists!.first.quantity! == 0) {
        _doneProducts.add(widget.product.sizeLists!.first);
      }
    }
  }

  @override
  void initState() {
    warnedSizeLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Box_View(
      horizontal: 0,
      boxInside: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    child: AppLargeText(
                      text: '${widget.product.title}',
                      maxLineCount: 2,
                    ),
                  ),
                ),
                FaIcon(
                  isExpanded
                      ? FontAwesomeIcons.angleUp
                      : FontAwesomeIcons.angleDown,
                  color: AppTheme.textColor,
                )
              ],
            ),
            isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              child: NetworkContainer(
                                imageUrl: widget.product.images!.length != 0
                                    ? widget.product.images!.first
                                    : NetworkImage(
                                        'http://robolink.com.tr/products/products.png'),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: paddingHorizontal),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: 'Ürünün Adı',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: paddingHorizontal),
                                      child:
                                          AppText(text: widget.product.title!),
                                    ),
                                    AppText(
                                      text: 'Ürünün Barkodu',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: paddingHorizontal),
                                      child: AppText(
                                          text: widget.product.barcode!),
                                    ),
                                    AppText(
                                      text: 'Ürünü Ekleyen Kişi',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    AppText(
                                        text: widget.product.adderUserName!),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.isNoneStock
                          ? ListView.builder(
                              itemCount: _doneProducts.length,
                              shrinkWrap: true,
                              padding: paddingZero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: paddingHorizontal / 2),
                                  child: Box_View(
                                    horizontal: 0,
                                    vertical: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                                  'Stoğun İsmi : ${_doneProducts[index].nameOfSize}',
                                              fontWeight: FontWeight.bold,
                                              maxLineCount: 1,
                                            ),
                                            AppText(
                                              text: _doneProducts[index]
                                                  .stockCode,
                                              maxLineCount: 1,
                                            ),
                                          ],
                                        )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AppText(
                                              text: 'Stok Sayısı',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            AppText(
                                              text: '0',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: _lowProducts.length,
                              shrinkWrap: true,
                              padding: paddingZero,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      bottom: paddingHorizontal / 2),
                                  child: Box_View(
                                    horizontal: 0,
                                    vertical: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text:
                                                  'Stoğun İsmi : ${_lowProducts[index].nameOfSize}',
                                              fontWeight: FontWeight.bold,
                                              maxLineCount: 1,
                                            ),
                                            AppText(
                                              text:
                                                  _lowProducts[index].stockCode,
                                              maxLineCount: 1,
                                            ),
                                          ],
                                        )),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AppText(
                                              text: 'Stok Sayısı',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            AppText(
                                              text:
                                                  '${_lowProducts[index].quantity}',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
