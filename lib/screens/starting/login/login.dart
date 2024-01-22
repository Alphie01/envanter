import 'dart:ui';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/screens/starting/register/register.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  final AnimationController? animationController;
  final Function? updatePage;
  const LoginScreen({Key? key, this.animationController, this.updatePage})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  Animation? reload;
  bool isLoading = false,
      securePassword = true,
      connectionResults = true,
      isLogedin = false,
      controlInternet = false;
  String mail = '', password = '';
  String error = '';

  @override
  void initState() {
    reload = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: widget.animationController!, curve: Curves.fastOutSlowIn));

    super.initState();
    widget.animationController!.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkUser() async {
    print('$mail - $password');
    Map user = await User.fetchUserbyMail(mail, password);

    print(user);
    if (user['id'] == 0) {
      widget.updatePage!(pageId: 94);
      /* setState(() {
        isLogedin = !isLogedin;
      }); */
    } else {
      setState(() {
        error = user['error_message'];
        isLoading = false;
      });
    }
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
                      children: [
                        Container(
                          child: connectionResults
                              ? isLogedin
                                  ? Container()
                                  : Scaffold(
                                      backgroundColor: Colors.transparent,
                                      resizeToAvoidBottomInset:
                                          false, // set it to false
                                      body: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Logo(),
                                            Box_View(
                                              horizontal: 0,
                                              boxInside: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text: 'E-Mail Adresiniz',
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  CustomTextfield(
                                                    hintText:
                                                        'E-mail Adresiniz',
                                                    color:
                                                        AppBlackTheme.textColor,
                                                    onChange: (news) {
                                                      setState(() {
                                                        mail = news;
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
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomTextfield(
                                                          obscureText:
                                                              securePassword,
                                                          hintText: 'Şifreniz',
                                                          isLast: true,
                                                          color: AppBlackTheme
                                                              .textColor,
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      paddingHorizontal /
                                                                          2),
                                                          child: Icon(
                                                            securePassword
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color: Colors.white,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 15),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color:
                                                            AppTheme.firstColor,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: paddingHorizontal /
                                                            2),
                                                    child: Column(
                                                      children: [
                                                        error != ''
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            paddingHorizontal),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
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
                                                                        size:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                    AppText(
                                                                      text:
                                                                          error,
                                                                      color: AppTheme
                                                                          .alertRed[0],
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : Container(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            /* Future.delayed(
                                                      Duration(seconds: 2), () {
                                                    SharedPref.addStringToSF(
                                                        userToken, 'value');
                                                    widget.updatePage!(pageId: 94);
                                                  }); */

                                                            checkUser();
                                                          },
                                                          child: Container(
                                                            width: double
                                                                .maxFinite,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            alignment: Alignment
                                                                .center,
                                                            child: AppLargeText(
                                                              text: 'Giriş Yap',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                                pageId: 93);
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 15,
                                                                    bottom: 25),
                                                            width: double
                                                                .maxFinite,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15),
                                                            alignment: Alignment
                                                                .center,
                                                            child: AppLargeText(
                                                              text: 'Kayıt Ol',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              size: 16,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: AppTheme
                                                                    .firstColor),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 25),
                                                            width: double
                                                                .maxFinite,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    top: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppTheme
                                                                            .firstColor))),
                                                            child: AppText(
                                                              size: 12,
                                                              text:
                                                                  'Sosyal Medya İle Giriş Yapmak İçin',
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      .7),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              socialLoginButton(
                                                                  FontAwesomeIcons
                                                                      .google),
                                                              socialLoginButton(
                                                                  FontAwesomeIcons
                                                                      .twitter),
                                                              socialLoginButton(
                                                                  FontAwesomeIcons
                                                                      .instagram),
                                                              socialLoginButton(
                                                                  FontAwesomeIcons
                                                                      .linkedin),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                    )
                              : Column(
                                  children: [
                                    Container(
                                      child: FaIcon(
                                        FontAwesomeIcons.wifi,
                                        color: Colors.white,
                                        size: 54,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: paddingHorizontal),
                                      child: AppText(
                                        text:
                                            'Sanırım Bağlantı Problemleri Yaşıyorsun!',
                                        color: Colors.white,
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
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              print('object');
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
                                                    color: Colors.white,
                                                  ),
                                                  FaIcon(
                                                    FontAwesomeIcons.refresh,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                        ),
                        GSOP_Mail_Comfirmation(
                          fetchedMap: {},
                          updatePage: widget.updatePage!,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container socialLoginButton(IconData fontAwesomeIcons) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: AppTheme.firstColor)),
      child: FaIcon(
        fontAwesomeIcons,
        color: Colors.white.withOpacity(.5),
      ),
    );
  }
}
