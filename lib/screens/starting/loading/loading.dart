import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:envanterimservetim/screens/starting/loading/components/CreateNewCompany.dart';
import 'package:envanterimservetim/screens/starting/loading/components/SelectExistedCompany.dart';
import 'package:envanterimservetim/screens/starting/loading/components/invited__shops.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/screens/starting/mail_comfimataion.dart';
import 'package:envanterimservetim/screens/starting/register/register.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class LoadingScreen extends StatefulWidget {
  final AnimationController? animationController;
  final bool isAuthed, isOnlyThemeChange;
  final Function setAutentication;
  final Function updatePage;

  const LoadingScreen(
      {Key? key,
      this.animationController,
      required this.isOnlyThemeChange,
      required this.updatePage,
      required this.isAuthed,
      required this.setAutentication})
      : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  int? selectedIndex;
  bool selectShop = false,
      waitFetch = false,
      _isSupportedAuth = false,
      isLoading = true,
      _authFailed = false;
  LocalAuthentication localAuthentication = LocalAuthentication();
  int initPage = 0;
  bool approved = false;
  PageController? pageController;
  AnimationController? _animationController;
  Animation<double>? _breathAnimation;

  @override
  void initState() {
    print('align : ${widget.isOnlyThemeChange}');

    localAuthentication.isDeviceSupported().then((bool isSupported) {
      setState(() {
        _isSupportedAuth = isSupported;
      });
    });
    initiliazeApp();
    setState(() {
      pageController = PageController(initialPage: initPage);
    });
    /* _getBiometric(); */

    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);
    _breathAnimation =
        Tween<double>(begin: 1, end: 0).animate(_animationController!);
    Shop.logoutAllShops();

    super.initState();
    widget.animationController!.forward();
  }

  Future<void> initiliazeApp() async {
    if (User.biometrics) {
      if (!widget.isAuthed) {
        bool biometricOkay = await _authenticate();
        if (biometricOkay) {
          widget.setAutentication();
          loginWithToken(SharedPref.getStringValuesSF(userToken));
        }
      } else {
        loginWithToken(SharedPref.getStringValuesSF(userToken));
      }
    } else {
      loginWithToken(SharedPref.getStringValuesSF(userToken));
      if (Shop.isSelectedShop()) {
        widget.updatePage(pageId: 0);
      } else {
        setState(
          () {
            selectShop = true;
          },
        );
      }
    }
  }

  void statusChange() {
    User.userProfile!.userStatus = UserStatus.approved;
    setState(() {
      approved = false;
    });
  }

//TODO Look The User Login With email doesnt fetch from database
  Future<bool> _authenticate() async {
    try {
      bool authenticated = await localAuthentication.authenticate(
          localizedReason:
              'İşletmenizin Güvenliği İçin Kendinizi Tanıtmalısınız!',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: false));

      return authenticated;
    } on PlatformException catch (e) {
      setState(() {
        _authFailed = true;
      });
      print('error' + e.toString());
      return false;
    }
  }

  Future loginWithToken(String token) async {
    setState(() {
      isLoading = false;
    });
    bool dance = await User.fetchUserbyToken(token);
    if (dance) {
      if (Shop.isSelectedShop()) {
        widget.updatePage(pageId: 0);
      } else {
        setState(
          () {
            isLoading = true;
            selectShop = true;
          },
        );
      }
    } else {
      SharedPref.removeStrValue(userToken);
      widget.updatePage(pageId: 92);
    }
  }

  Future setSelectedShop() async {
    setState(() {
      waitFetch = !waitFetch;
    });
    Shop.setSelectedShop(Shop.attendedShops[selectedIndex!]);
    bool dance = await Shop.shop_init();
    if (dance) {
      widget.updatePage(pageId: 0);
    } else {}
  }

  Future setNewSelectedShop(String token) async {
    setState(() {
      waitFetch = !waitFetch;
    });

    bool dance = await Shop.shop_initByToken(token);
    if (dance) {
      widget.updatePage(pageId: 0);
    } else {}
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Future<void> _getBiometric() async {
    List<BiometricType> _listBiometric =
        await localAuthentication.getAvailableBiometrics();

    if (!mounted) {
      return;
    }
  }

  void setCompany(int page) {
    _animationController!.forward();
    setState(() {
      pageController!.jumpToPage(page);
    });
    _animationController!.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(
          top: getPaddingScreenTopHeight(),
          bottom: getPaddingScreenBottomHeight()),
      color: AppTheme.firstColor,
      child: User.userProfile != null
          ? User.userProfile!.userStatus == UserStatus.notApproved || approved
              ? GSOP_Mail_Comfirmation(fetchedMap: {
                  'kullanici_mail': User.userProfile!.userMail,
                  'kullanici_secretToken': User.userProfile!.token,
                }, updatePage: statusChange)
              : selectShop
                  ? isLoading
                      ? Shop.attendedShops.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.all(paddingHorizontal * 2),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.all(paddingHorizontal * 2),
                                    child: AppText(
                                      text:
                                          'Hangi İşletmeni Kontrol Etmek İstersin?',
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.bold,
                                      size: 14,
                                      align: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: GridView.builder(
                                      padding: paddingZero,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing:
                                                  paddingHorizontal,
                                              mainAxisSpacing:
                                                  paddingHorizontal),
                                      itemCount: Shop.attendedShops.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                      child: NetworkContainer(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        imageUrl: Shop
                                                            .attendedShops[
                                                                index]
                                                            .shop_image,
                                                      ),
                                                    ),
                                                    Container(
                                                      child: AppText(
                                                        text: Shop
                                                            .attendedShops[
                                                                index]
                                                            .shop_name,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              selectedIndex == index
                                                  ? Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: AppTheme
                                                                .contrastColor1,
                                                          )),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.check,
                                                        size: 14,
                                                        color: AppTheme
                                                            .contrastColor1,
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  selectedIndex != null
                                      ? waitFetch
                                          ? Center(
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setSelectedShop();
                                              },
                                              child: Box_View(
                                                horizontal: 0,
                                                boxInside: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    AppText(
                                                      text: 'Devam Et',
                                                      align: TextAlign.center,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme
                                                          .contrastColor1,
                                                      size: 14,
                                                    ),
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .arrowRight,
                                                      color: AppTheme
                                                          .contrastColor1,
                                                      size: 14,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(),
                                ],
                              ),
                            )
                          : AnimatedBuilder(
                              animation: _animationController!,
                              builder: (BuildContext context, Widget? child) {
                                return Opacity(
                                  opacity: _breathAnimation!.value,
                                  child: Container(
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    alignment: Alignment.center,
                                    child: PageView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: pageController!,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Logo(),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Shop.invitedShops.isNotEmpty
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            await showModalBottomSheet(
                                                              context: context,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (builder) {
                                                                return Invited_Shops();
                                                              },
                                                            );
                                                            loginWithToken(SharedPref
                                                                .getStringValuesSF(
                                                                    userToken));
                                                          },
                                                          child: Box_View(
                                                              boxInside: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    AppText(
                                                                      text:
                                                                          '${Shop.invitedShops.length} işletme seni işletmesine davet ediyor!',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      size: 13,
                                                                    ),
                                                                    AppText(
                                                                        text:
                                                                            'Olan bir işletme seni bünyesine katmak istiyor! Hemen gözat!'),
                                                                  ],
                                                                ),
                                                              ),
                                                              FaIcon(
                                                                  FontAwesomeIcons
                                                                      .box,
                                                                  color: AppTheme
                                                                      .textColor)
                                                            ],
                                                          )),
                                                        )
                                                      : Container(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setCompany(1);
                                                    },
                                                    child: Box_View(
                                                        boxInside: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text:
                                                                    'Olan Bir İşletmenin Altına Giriş Yap',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                size: 13,
                                                              ),
                                                              AppText(
                                                                  text:
                                                                      'Olan bir işletmenin altına giriş yaparak, o işletmenin altında işlemler yapabilirsiniz.'),
                                                            ],
                                                          ),
                                                        ),
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .qrcode,
                                                            color: AppTheme
                                                                .textColor)
                                                      ],
                                                    )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => setCompany(2),
                                                    child: Box_View(
                                                        boxInside: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text:
                                                                    'Kendi İşletmeni Oluştur!',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                size: 13,
                                                              ),
                                                              AppText(
                                                                  text:
                                                                      'Kendi işletmenin profilini uygulama üzerinden oluşturabilir; İster webden, ister mobilden erişim sağla'),
                                                            ],
                                                          ),
                                                        ),
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                            color: AppTheme
                                                                .textColor)
                                                      ],
                                                    )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      loginWithToken(SharedPref
                                                          .getStringValuesSF(
                                                              userToken));
                                                    },
                                                    child: Box_View(
                                                        boxInside: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text: 'Yenile',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                size: 13,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        FaIcon(
                                                            FontAwesomeIcons
                                                                .refresh,
                                                            color: AppTheme
                                                                .textColor)
                                                      ],
                                                    )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      SharedPref.removeStrValue(
                                                          userToken);
                                                      widget.updatePage(
                                                          pageId: 92);
                                                    },
                                                    child: Box_View(
                                                        boxInside: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              AppText(
                                                                text:
                                                                    'Çıkış Yap',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                size: 13,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        FaIcon(
                                                            FontAwesomeIcons.x,
                                                            color: AppTheme
                                                                .textColor)
                                                      ],
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SelectExistedCompany(
                                          goBackToFirstPage: () =>
                                              setCompany(0),
                                          approved: (String token) {
                                            setNewSelectedShop(token);
                                          },
                                        ),
                                        CreateNewCompany(
                                          goBackToFirstPage: () =>
                                              setCompany(0),
                                          endOfCreation: () {
                                            widget.updatePage(pageId: 0);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                      : Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                  : _authFailed
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Logo(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingHorizontal * 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: AppText(
                                      text:
                                          'Kendinizi Tanıtma İşlemi Tamamlanmamıştır!',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _authFailed = !_authFailed;
                                      });
                                      initiliazeApp();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: paddingHorizontal),
                                      padding:
                                          EdgeInsets.all(paddingHorizontal),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius: defaultRadius),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'Tekrar Tanıt',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.lock,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      SharedPref.removeStrValue(userToken);
                                      widget.updatePage(pageId: 92);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(paddingHorizontal),
                                      decoration: BoxDecoration(
                                          color: AppTheme.alertRed[0],
                                          border: Border.all(
                                              color: AppTheme.alertRed[0]),
                                          borderRadius: defaultRadius),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: 'Çıkış Yap',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.x,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      : WaitingRoom()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Logo(),
                Padding(
                  padding: EdgeInsets.only(bottom: paddingHorizontal),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

class WaitingRoom extends StatelessWidget {
  const WaitingRoom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Logo(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(bottom: 50),
              child: CircularProgressIndicator(
                color: AppTheme.background,
              ),
            ),
            Container(
              child: AppText(
                text: 'İşletmenizin Güvenliği İçin Kendinizi Tanıtmalısınız!',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        )
      ],
    );
  }
}
