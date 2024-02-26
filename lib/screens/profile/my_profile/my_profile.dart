import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  User? selectedUser;
  AnimationController? headerAnimationController;
  Animation<double>? headerAnimation;
  double offset = 0;
  Color iconColor = Colors.white;
  @override
  void initState() {
    setState(() {
      selectedUser = User.userProfile;
    });
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    headerAnimationController =
        AnimationController(vsync: this, duration: defaultDuration);

    headerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(headerAnimationController!);

    scrollController.addListener(() {
      setState(() {
        offset = scrollController.offset;
      });
      if (scrollController.offset > 25) {
        setState(() {
          iconColor = AppTheme.textColor;
        });
        headerAnimationController!.forward();
      } else {
        setState(() {
          iconColor = Colors.white;
        });
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

  String nullChecker(String? str) {
    return str == null ? 'Belirtilmedi' : str;
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
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .35,
                            child: NetworkContainer(
                                imageUrl: selectedUser!.userPThumbNail),
                          ),
                          ListView(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .25),
                            shrinkWrap: true,
                            controller: scrollController,
                            children: [
                              Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: NetworkContainer(
                                    imageUrl: selectedUser!.userProfilePhoto,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(paddingHorizontal),
                                  ),
                                  color: AppTheme.background,
                                ),
                                child: Column(
                                  children: [
                                    Box_View(
                                      vertical: paddingHorizontal,
                                      boxInside: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppLargeText(
                                            text: 'Kişisel Bilgiler',
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'İsminiz',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userName)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'TC Kimlik Numaranız',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userTC)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Kullanıcı Adınız',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userKAdi)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Email Adresiniz',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userMail)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Doğum Tarihiniz',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userBirthdate)}',
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Box_View(
                                      vertical: paddingHorizontal,
                                      boxInside: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppLargeText(
                                            text: 'İletişim Bilgiler',
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Telefon Numaranız',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userGsm)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Adresiniz',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userAdres)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Bulunduğunuz İl',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userIl)}',
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    paddingHorizontal * .5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Bulunduğunuz İlçe',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                AppText(
                                                  text:
                                                      '${nullChecker(selectedUser!.userIlce)}',
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Box_View(
                                      boxInside: Column(
                                        children: [
                                          Row(
                                            children: [
                                              AppLargeText(
                                                text: 'Bulunduğun İşletmeler',
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: paddingHorizontal * .5),
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
                                                    text:
                                                        '${Shop.selectedShop!.shop_name}',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  AppText(
                                                      text: 'Seçili İşletme')
                                                ],
                                              ),
                                            ),
                                          ),
                                          Shop.attendedShops.isNotEmpty
                                              ? ListView.builder(
                                                  itemCount:
                                                      Shop.attendedShops.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    Shop shop = Shop
                                                        .attendedShops[index];
                                                    return Box_View(
                                                      horizontal: 0,
                                                      color:
                                                          AppTheme.background,
                                                      boxInside: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AppText(
                                                            text:
                                                                '${shop.shop_name}',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.updatePage!(pageId: 32);
                                      },
                                      child: Box_View(
                                        color: AppTheme.contrastColor1
                                            .withOpacity(.6),
                                        boxInside: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppLargeText(
                                                text: 'Bilgilerini Düzenle'),
                                            FaIcon(
                                              FontAwesomeIcons.arrowRight,
                                              color: AppTheme.textColor,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
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
