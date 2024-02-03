import 'dart:ui';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/stringConstans.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/screens/starting/mail_comfimataion.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  final AnimationController? animationController;
  final Function? updatePage;
  const RegisterScreen({Key? key, this.animationController, this.updatePage})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  Animation? reload;
  bool isLoading = false,
      securePassword = true,
      showWhyTelephoneNumber = false,
      showWhyAdress = false,
      connectionResults = true,
      isLogedin = false,
      controlInternet = false;
  PageController _pageController = PageController();

  TextEditingController _editingController1 = TextEditingController(),
      _editingController2 = TextEditingController(),
      _editingController3 = TextEditingController(),
      _editingController4 = TextEditingController(),
      _editingController6 = TextEditingController(),
      _editingController5 = TextEditingController(),
      _editingController = TextEditingController();

  Map<String, dynamic> fetchedMap = {};
  String mail = '',
      password = '',
      password_second = '',
      pressedGender = 'Belirtmek İstemiyorum';

  String formName = '',
      formUsername = '',
      formEmail = '',
      formGender = '',
      formTelephone = '',
      formAdres = '';
  FocusNode _focusNode = FocusNode(),
      _focusNode1 = FocusNode(),
      _focusNode2 = FocusNode();
//TODO Gizlilik ve anlaşmalar
  double valueOfOpacity = 0.0, logoOpacity = 1;
  ScrollController scrollController = ScrollController();
  List<String> error = [];

  @override
  void initState() {
    reload = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: widget.animationController!, curve: Curves.fastOutSlowIn));
    scrollController.addListener(() {
      setOpacity(scrollController.offset);
    });

    super.initState();
    widget.animationController!.forward();
  }

  void setOpacity(double value) {
    if (value > 0) {
      if (value < 100) {
        setState(() {
          logoOpacity = 1 - (value / 100);
          valueOfOpacity = value / 100;
        });
      } else {
        setState(() {
          logoOpacity = 0;
          valueOfOpacity = 1;
        });
      }
    }
    if (value <= 0) {
      setState(() {
        logoOpacity = 1;
        valueOfOpacity = 0;
      });
    }
  }

  Future registeruser() async {
    checkFault();

    if (error.isEmpty) {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic>? dance =
          await User.register_account(registerMapJSON());
      if (dance!['kullanici_mail'] != null) {
        setState(() {
          fetchedMap = dance;
        });
        setOpacity(0);
        _pageController.nextPage(
            duration: defaultDuration, curve: Curves.easeInOut);
      } else {
        setState(() {
          isLoading = false;
        });
        error.add(dance['error_message']);
      }
    }
  }

  Map<String, dynamic> registerMapJSON() {
    return {
      'kullanici_register': 'ok',
      'kullanici_adsoyad': formName,
      'kullanici_password': password,
      'kullanici_gender': formGender,
      'kullanici_adres': formAdres,
      'kullanici_gsm': formTelephone,
      'kullanici_ad': formUsername,
      'kullanici_mail': formEmail
    };
  }

  void checkFault() {
    print(formName);
    setState(() {
      error = [];
      if (formName.length < 3) {
        error.add('İsminizi yazmak zorundasınız.');
      }
      if (formUsername.length < 3) {
        error.add('Kullanıcı isminizi yazmak zorundasınız.');
      }
      if (!isEmailValid(formEmail)) {
        error.add('Emailinizi geçerli yazmak zorundasınız.');
      }
      if (password != password_second) {
        error.add('Yazdığınız şifreler uyuşmamaktadır.');
      }
      if (password.length < 6) {
        error.add('Belirlediğiniz şifre 6 haneden fazla olmalıdır.');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: reload!,
      builder: ((context, child) {
        return Opacity(
          opacity: reload!.value,
          child: Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    width: double.maxFinite,
                    height: SizeConfig.screenHeight,
                    padding: EdgeInsets.fromLTRB(
                        paddingHorizontal,
                        getPaddingScreenTopHeight(),
                        paddingHorizontal,
                        getPaddingScreenBottomHeight()),
                    decoration: BoxDecoration(
                      color: AppBlackTheme.background,
                    ),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        Container(
                          child: connectionResults
                              ? isLogedin
                                  ? Container()
                                  : ListView(
                                      controller: scrollController,
                                      children: [
                                        Opacity(
                                          opacity: logoOpacity,
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              },
                                              child: Logo()),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'İsminiz',
                                                size: 16,
                                              ),
                                              CustomTextfield(
                                                hintText: 'İsminiz',
                                                focusNode: _focusNode,
                                                controller: _editingController,
                                                color: AppTheme.textColor,
                                                onChange: (news) {
                                                  setState(() {
                                                    formName = news;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'Kullanıcı Adınız',
                                                size: 16,
                                              ),
                                              CustomTextfield(
                                                hintText: 'Kullanıcı Adınız',
                                                color: AppTheme.textColor,
                                                focusNode: _focusNode1,
                                                controller: _editingController1,
                                                onChange: (news) {
                                                  setState(() {
                                                    formUsername = news;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'E-Mail Adresiniz',
                                                size: 16,
                                              ),
                                              CustomTextfield(
                                                hintText: 'E-mail Adresiniz',
                                                color: AppTheme.textColor,
                                                focusNode: _focusNode2,
                                                controller: _editingController2,
                                                onChange: (news) {
                                                  setState(() {
                                                    mail = news;
                                                    formEmail = news;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'Cinsiyetiniz',
                                                size: 16,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (builder) {
                                                      return Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    paddingHorizontal),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme
                                                              .background,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top: Radius.circular(
                                                                paddingHorizontal),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Box_View(
                                                              boxInside:
                                                                  Container(
                                                                width: double
                                                                    .maxFinite,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              paddingHorizontal / 2),
                                                                      child:
                                                                          AppLargeText(
                                                                        text:
                                                                            'Cinsiyetiniz',
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          pressedGender =
                                                                              'Erkek';
                                                                          formGender =
                                                                              '1';
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Box_View(
                                                                        horizontal:
                                                                            0,
                                                                        color: pressedGender ==
                                                                                'Erkek'
                                                                            ? AppTheme.contrastColor1.withOpacity(.4)
                                                                            : AppTheme.background,
                                                                        boxInside:
                                                                            Container(
                                                                          width:
                                                                              double.maxFinite,
                                                                          child:
                                                                              AppText(
                                                                            text:
                                                                                'Erkek',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          pressedGender =
                                                                              'Kadın';
                                                                          formGender =
                                                                              '2';
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Box_View(
                                                                        horizontal:
                                                                            0,
                                                                        color: pressedGender ==
                                                                                'Kadın'
                                                                            ? AppTheme.contrastColor1.withOpacity(.4)
                                                                            : AppTheme.background,
                                                                        boxInside:
                                                                            Container(
                                                                          width:
                                                                              double.maxFinite,
                                                                          child:
                                                                              AppText(
                                                                            text:
                                                                                'Kadın',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          pressedGender =
                                                                              'Belirtmek İstemiyorum';
                                                                          formGender =
                                                                              '3';
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Box_View(
                                                                        horizontal:
                                                                            0,
                                                                        color: pressedGender ==
                                                                                'Belirtmek İstemiyorum'
                                                                            ? AppTheme.contrastColor1.withOpacity(.4)
                                                                            : AppTheme.background,
                                                                        boxInside:
                                                                            Container(
                                                                          width:
                                                                              double.maxFinite,
                                                                          child:
                                                                              AppText(
                                                                            text:
                                                                                'Belirtmek İstemiyorum',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
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
                                                child: Box_View(
                                                  horizontal: 0,
                                                  color: AppTheme.contrastColor1
                                                      .withOpacity(.6),
                                                  boxInside: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                          text: pressedGender),
                                                      FaIcon(
                                                          FontAwesomeIcons
                                                              .angleRight,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: 'Adresiniz',
                                                    size: 16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showWhyAdress =
                                                            !showWhyAdress;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppTheme.textColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.info,
                                                        color:
                                                            AppTheme.background,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              showWhyAdress
                                                  ? Container(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical:
                                                              paddingHorizontal /
                                                                  2),
                                                      child:
                                                          App_Rich_Text(text: [
                                                        'Adresiniz ',
                                                        'başvurduğunuz firmanın',
                                                        ' bilgisine sunulacaktır. Adresinizi ',
                                                        'işletme ve sizin ',
                                                        'dışınızda kimse tarafından görüntülenemez.'
                                                      ]),
                                                    )
                                                  : Container(),
                                              CustomTextfield(
                                                hintText: 'Adresiniz',
                                                maxLineCount: 2,
                                                color: AppTheme.textColor,
                                                controller: _editingController3,
                                                onChange: (news) {
                                                  setState(() {
                                                    formAdres = news;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: 'Telefon Numaranız',
                                                    size: 16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        showWhyTelephoneNumber =
                                                            !showWhyTelephoneNumber;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppTheme.textColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.info,
                                                        color:
                                                            AppTheme.background,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              showWhyTelephoneNumber
                                                  ? Container(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical:
                                                              paddingHorizontal /
                                                                  2),
                                                      child:
                                                          App_Rich_Text(text: [
                                                        'Telefon numaranızı ',
                                                        'başvurduğunuz firmanın',
                                                        ' bilgisine sunulacaktır. Telefon numaranızı ',
                                                        'işletme ve sizin ',
                                                        'dışınızda kimse tarafından görüntülenemez.'
                                                      ]),
                                                    )
                                                  : Container(),
                                              CustomTextfield(
                                                hintText: 'Telefon Numaranız',
                                                color: AppTheme.textColor,
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: _editingController4,
                                                onChange: (news) {
                                                  setState(() {
                                                    formTelephone = news;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'Şifreniz',
                                                size: 16,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomTextfield(
                                                      obscureText:
                                                          securePassword,
                                                      hintText: 'Şifreniz',
                                                      controller:
                                                          _editingController5,
                                                      isLast: true,
                                                      color: AppTheme.textColor,
                                                      onChange: (news) {
                                                        setState(() {
                                                          password = news;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        securePassword =
                                                            !securePassword;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              paddingHorizontal /
                                                                  2),
                                                      child: Icon(
                                                        securePassword
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Box_View(
                                          horizontal: 0,
                                          boxInside: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text: 'Şifreniz',
                                                size: 16,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CustomTextfield(
                                                      obscureText:
                                                          securePassword,
                                                      hintText: 'Şifreniz',
                                                      controller:
                                                          _editingController6,
                                                      isLast: true,
                                                      color: AppTheme.textColor,
                                                      onChange: (news) {
                                                        setState(() {
                                                          password_second =
                                                              news;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        securePassword =
                                                            !securePassword;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                              paddingHorizontal /
                                                                  2),
                                                      child: Icon(
                                                        securePassword
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        isLoading
                                            ? Container(
                                                width: double.maxFinite,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 15),
                                                alignment: Alignment.center,
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: AppTheme.firstColor,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  error.isNotEmpty
                                                      ? ListView.builder(
                                                          itemCount:
                                                              error.length,
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          padding: paddingZero,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Box_View(
                                                              horizontal: 0,
                                                              boxInside: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        right:
                                                                            paddingHorizontal),
                                                                    child:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .xmark,
                                                                      color: AppTheme
                                                                          .alertRed[0],
                                                                      size: 12,
                                                                    ),
                                                                  ),
                                                                  AppText(
                                                                    text: error[
                                                                        index],
                                                                    color: AppTheme
                                                                        .alertRed[0],
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : Container(),
                                                  GestureDetector(
                                                    onTap: registeruser,
                                                    child: Container(
                                                      width: double.maxFinite,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              paddingHorizontal /
                                                                  2),
                                                      alignment:
                                                          Alignment.center,
                                                      child: AppLargeText(
                                                        text: 'Kayıt Ol',
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        size: 16,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppTheme
                                                                  .firstColor)),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      widget.updatePage!(
                                                          pageId: 92);
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 15, bottom: 25),
                                                      width: double.maxFinite,
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      alignment:
                                                          Alignment.center,
                                                      child: AppLargeText(
                                                        text: 'Giriş Yap',
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        size: 16,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          color: AppTheme
                                                              .firstColor),
                                                    ),
                                                  ),
                                                ],
                                              )
                                      ],
                                    )
                              : Column(
                                  children: [
                                    Container(
                                      child: FaIcon(
                                        FontAwesomeIcons.wifi,
                                        size: 54,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: paddingHorizontal),
                                      child: AppText(
                                        text:
                                            'Sanırım Bağlantı Problemleri Yaşıyorsun!',
                                        size: 24,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          bottom: paddingHorizontal * 3),
                                      child: AppText(
                                        text:
                                            'Bu uygulama, internet üzerinden bilgi alışverişi sağlayan bir platform olarak tasarlanmıştır. Uygulamayı verimli bir şekilde kullanabilmek ve tüm özelliklerine erişebilmek için internet bağlantınızın aktif olması gerekmektedir. İnternet bağlantısı, uygulamanın sorunsuz çalışmasını ve kullanıcıların istedikleri bilgilere hızlı bir şekilde ulaşmalarını sağlar.',
                                        maxLineCount: 999,
                                        align: TextAlign.center,
                                      ),
                                    ),
                                    controlInternet
                                        ? Container(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                controlInternet = true;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                  paddingHorizontal),
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppTheme.contrastColor1),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                    text: 'Tekrar Kontrol Et',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  FaIcon(
                                                    FontAwesomeIcons.refresh,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                        ),
                        GSOP_Mail_Comfirmation(
                          fetchedMap: fetchedMap,
                          updatePage: () {
                            widget.updatePage!(pageId: 94);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: valueOfOpacity,
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(top: getPaddingScreenTopHeight()),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(paddingHorizontal)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.contrastColor1.withOpacity(.3),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      height: AppBar().preferredSize.height,
                      padding: EdgeInsets.symmetric(
                          horizontal: paddingHorizontal * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(left: paddingHorizontal),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: AppBar().preferredSize.height -
                                          1.75 * paddingHorizontal,
                                      width: AppBar().preferredSize.height -
                                          1.75 * paddingHorizontal,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AppTheme.logo,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: paddingHorizontal / 2),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text: 'Envanterim',
                                            size: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          AppText(
                                            text: 'İş Hayatım',
                                            size: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
