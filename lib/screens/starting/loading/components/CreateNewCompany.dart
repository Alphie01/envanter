// ignore_for_file: camel_case_types

import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/loadingCircular.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateNewCompany extends StatefulWidget {
  const CreateNewCompany({
    super.key,
    required this.goBackToFirstPage,
    required this.endOfCreation,
  });
  final Function goBackToFirstPage;
  final Function endOfCreation;
  @override
  State<CreateNewCompany> createState() => _CreateNewCompanyState();
}

class _CreateNewCompanyState extends State<CreateNewCompany> {
  String shopName = '',
      shopAdress = '',
      shopGsm = '',
      shopEmail = '',
      shopPrivacy = '0';
  bool boolName = false,
      boolAdress = false,
      boolGsm = false,
      boolEmail = false,
      isCreated = false,
      isCreating = false;

  PageController? _pageController = PageController();
  int initialPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: initialPage);
    super.initState();
  }

  bool checkTextfields() {
    setState(() {
      boolName = false;
      boolAdress = false;
      boolGsm = false;
      boolEmail = false;
    });
    int count = 0;
    if (shopName == '') {
      setState(() {
        count++;
        boolName = true;
      });
    }
    if (shopAdress == '') {
      setState(() {
        count++;
        boolAdress = true;
      });
    }
    if (shopGsm == '') {
      setState(() {
        count++;
        boolGsm = true;
      });
    }
    if (shopEmail == '') {
      setState(() {
        count++;
        boolEmail = true;
      });
    }

    return count == 0 ? true : false;
  }

  Future<void> createNewShop() async {
    if (checkTextfields()) {
      setState(() {
        isCreating = true;
      });
      bool dance = await Shop.createNewShop(creationMapCreator());

      setState(() {
        isCreating = false;
        isCreated = dance;
      });
      if (isCreated) {
        _pageController!.jumpToPage(1);
      }
    }
  }

  Map<String, dynamic> creationMapCreator() {
    Map<String, dynamic> returns = {
      'createNewShop': 'ok',
      'user_id': User.userProfile!.userId,
      'shop_name': shopName,
      'shop_privacy': int.parse(shopPrivacy),
      'shop_adres': shopAdress,
      'shop_gsm': int.parse(shopGsm),
      'shop_eposta': shopEmail
    };
    return returns;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Stack(
        children: [
          Column(
            children: [
              Logo(),
              Expanded(
                child: Box_View(
                  boxInside: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      isCreating
                          ? LoadingCircular()
                    
                          : ListView(
                              shrinkWrap: true,
                              padding: paddingZero,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: paddingHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'İşletmenizin İsmi',
                                        color: AppTheme.textColor,
                                      ),
                                      CustomTextfield(
                                        hintText: 'İşletmenin İsmi',
                                        onChange: (String string) {
                                          setState(() {
                                            shopName = string;
                                          });
                                        },
                                      ),
                                      boolName
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: paddingHorizontal),
                                              child: AppText(
                                                text:
                                                    'İşletmenizin İsmini Belirtmeniz Gerekmektedir.',
                                                color: AppTheme.alertRed[0],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: paddingHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'İşletmenizin Adresi',
                                        color: AppTheme.textColor,
                                      ),
                                      CustomTextfield(
                                        hintText: 'İşletmenin Adresi',
                                        onChange: (String string) {
                                          setState(() {
                                            shopAdress = string;
                                          });
                                        },
                                      ),
                                      boolAdress
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: paddingHorizontal),
                                              child: AppText(
                                                text:
                                                    'İşletmenizin Adresini Belirtmeniz Gerekmektedir.',
                                                color: AppTheme.alertRed[0],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: paddingHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'İşletmenizin Telefon Numarası',
                                        color: AppTheme.textColor,
                                      ),
                                      CustomTextfield(
                                        hintText: 'İşletmenin Telefon Numarası',
                                        keyboardType: TextInputType.number,
                                        onChange: (String string) {
                                          setState(() {
                                            shopGsm = string;
                                          });
                                        },
                                      ),
                                      boolGsm
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: paddingHorizontal),
                                              child: AppText(
                                                text:
                                                    'İşletmenizin Telefonunu Belirtmeniz Gerekmektedir.',
                                                color: AppTheme.alertRed[0],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: paddingHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text:
                                            'İletişim İçin Kullanılacak E-posta',
                                        color: AppTheme.textColor,
                                      ),
                                      CustomTextfield(
                                        hintText:
                                            'İşletmenizin İletişim İçin Kullanılacak E-posta',
                                        onChange: (String string) {
                                          setState(() {
                                            shopEmail = string;
                                          });
                                        },
                                      ),
                                      boolEmail
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: paddingHorizontal),
                                              child: AppText(
                                                text:
                                                    'İşletmenizin E-postasını Belirtmeniz Gerekmektedir.',
                                                color: AppTheme.alertRed[0],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: paddingHorizontal),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppLargeText(
                                        text: 'İşletmenizin Gizlilik Durumu',
                                        color: AppTheme.textColor,
                                      ),
                                      Privacy_Selection(
                                        setPrivacy: (String string) {
                                          setState(() {
                                            shopPrivacy = string;
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(paddingHorizontal),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.alertGreen[0],
                                )),
                            child: FaIcon(
                              FontAwesomeIcons.check,
                              color: AppTheme.alertGreen[0],
                              size: 36,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: paddingHorizontal),
                            child: AppLargeText(
                              text:
                                  'İşletmeniz Başarılı Bir Şekilde Oluşturulmuştur.',
                              align: TextAlign.center,
                              color: AppTheme.textColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: paddingHorizontal),
                            child: AppText(
                              text:
                                  'Envanterim İş Hayatım uygulamasını ihtiyacınız doğrultusunda özgürce kullanabilirsiniz! İşletmenizin spesifik ihtiyaçlarına uygun özellikleri ekleyerek, daha kaliteli bir içerik elde edebilirsiniz.',
                              align: TextAlign.center,
                              maxLineCount: 10,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              isCreated
                  ? Column(
                      children: [
                        Box_View(
                          boxInside: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AppLargeText(
                                  text:
                                      'İşletmeme Ekleyebileceğim Özellikleri İncelemek İstiyorum',
                                  color: AppTheme.textColor,
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.cog,
                                color: AppTheme.textColor,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.endOfCreation();
                          },
                          child: Box_View(
                            boxInside: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLargeText(
                                  text: 'Şimdi İşletme Giriş Yap',
                                  color: AppTheme.textColor,
                                ),
                                FaIcon(
                                  FontAwesomeIcons.lock,
                                  color: AppTheme.textColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: createNewShop,
                      child: Box_View(
                        boxInside: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppLargeText(
                              text: 'Şimdi İşletme Kaydını Oluştur',
                              color: AppTheme.textColor,
                            ),
                            FaIcon(
                              FontAwesomeIcons.plus,
                              color: AppTheme.textColor,
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
          isCreated
              ? Container()
              : GestureDetector(
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
      ),
    );
  }
}

class Privacy_Selection extends StatefulWidget {
  const Privacy_Selection({
    super.key,
    required this.setPrivacy,
  });
  final Function setPrivacy;
  @override
  State<Privacy_Selection> createState() => _Privacy_SelectionState();
}

class _Privacy_SelectionState extends State<Privacy_Selection> {
  String actualText = 'İşletmem Gizli Olsun';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              padding: EdgeInsets.all(paddingHorizontal),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(paddingHorizontal),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: 'İşletmenizin Gizlilik Durumunu Değiştir'),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        actualText = 'İşletmem Gizli Olsun';
                        widget.setPrivacy('0');
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: paddingHorizontal),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.only(right: paddingHorizontal),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: 'İşletmem Gizli Olsun (Önerilen)',
                                    fontWeight: FontWeight.bold,
                                    size: 13,
                                  ),
                                  AppText(
                                    text:
                                        'İşletmem gizli olsun, katılmak isteyenler QR kodu okuttuktan sonra yetkili onayından geçsin. ',
                                    color: AppTheme.textColor.withOpacity(.6),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.lock,
                            color: AppTheme.textColor,
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        actualText = 'İşletmem Açık Olsun';
                        widget.setPrivacy('1');
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  EdgeInsets.only(right: paddingHorizontal),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppText(
                                    text: 'İşletmem Açık Olsun',
                                    fontWeight: FontWeight.bold,
                                    size: 13,
                                  ),
                                  AppText(
                                    text:
                                        'İşletmem açık olsun, katılmak isteyenler QR kodu okuttuktan işletmeye katılabilsin. ',
                                    color: AppTheme.textColor.withOpacity(.6),
                                  )
                                ],
                              ),
                            ),
                          ),
                          FaIcon(
                            FontAwesomeIcons.lockOpen,
                            color: AppTheme.textColor,
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
      child: Container(
        margin: EdgeInsets.only(top: paddingHorizontal),
        width: double.maxFinite,
        padding: EdgeInsets.all(paddingHorizontal),
        decoration: BoxDecoration(
            borderRadius: defaultRadius,
            border: Border.all(color: AppTheme.contrastColor1)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(right: paddingHorizontal),
                child: AppText(text: actualText),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.angleDown,
              color: AppTheme.textColor,
            )
          ],
        ),
      ),
    );
  }
}
