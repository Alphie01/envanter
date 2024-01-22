import 'dart:math';
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/stockspage/components/parentCatagories.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GestureCategoriesModal extends StatefulWidget {
  const GestureCategoriesModal({
    super.key,
  });

  @override
  State<GestureCategoriesModal> createState() => _GestureCategoriesModalState();
}

class _GestureCategoriesModalState extends State<GestureCategoriesModal> {
  String menuTypeName = '',
      subMenuName = 'Hayır, Herhangi Üst Menu Bulunmamaktadır!';
  int subId = -1;
  double size = .55;
  int? randomInt;
  FocusNode focusNode = FocusNode();
  bool error = false;
  @override
  void initState() {
    setState(() {
      randomInt = Random().nextInt(89999) + 1000;
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          size = .9;
        });
      } else {
         setState(() {
          size = .55;
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Future createNew() async {
    if (menuTypeName == '') {
      setState(() {
        error = true;
      });
      FocusScope.of(context).requestFocus(FocusNode());
    } else {
      bool result = await Categories.createNewCategories(Categories(
          name: menuTypeName, menuTypeId: randomInt!, subCategoriesId: subId));
      if (result) {
        Navigator.pop(context);
      } else {
        setState(() {
          error = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: size,
      maxChildSize: size,
      builder: (_, controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(paddingHorizontal),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                Box_View(
                  boxInside: Container(
                    width: double.maxFinite,
                    child: AppLargeText(
                      text: 'Yeni Kategori Ekle',
                    ),
                  ),
                ),
                Box_View(
                  boxInside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppLargeText(
                        text: 'Kategori İsim',
                        size: 14,
                      ),
                      CustomTextfield(
                        hintText: 'Kategori İsmi',
                        focusNode: focusNode,
                        onChange: (category) {
                          setState(() {
                            menuTypeName = category;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Box_View(
                  boxInside: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: AppLargeText(
                          text: 'Kategori Üst Kategorisi Var Mı?',
                          size: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return ParentCatagories(
                                selectedCatagories: (String subClassName,
                                    int subClassInt, int s) {
                                  setState(() {
                                    subMenuName = subClassName;
                                    subId = subClassInt;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(paddingHorizontal),
                          decoration: BoxDecoration(
                              borderRadius: defaultRadius,
                              border:
                                  Border.all(color: AppTheme.contrastColor1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(text: subMenuName),
                              FaIcon(
                                FontAwesomeIcons.angleDown,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                error
                    ? Container(
                        padding: EdgeInsets.only(bottom: paddingHorizontal),
                        child: Row(
                          children: [
                            AppText(
                              text: 'Kategori İsminiz Boş Olamaz!',
                              color: AppTheme.alertRed[0],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                GestureDetector(
                  onTap: () {
                    createNew();
                  },
                  child: Box_View(
                    color: AppTheme.contrastColor1,
                    boxInside: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLargeText(
                          text: 'Yeni Kategori Ekle',
                          color: Colors.white,
                        ),
                        FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
