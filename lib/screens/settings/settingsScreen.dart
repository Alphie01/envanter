import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/invited__shops.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainSettingsPage extends StatefulWidget {
  const MainSettingsPage(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _MainSettingsPageState createState() => _MainSettingsPageState();
}

class _MainSettingsPageState extends State<MainSettingsPage>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  //TODO create sub pages

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
    widget.animationController!.forward();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void _showAlertDialogQuitCompany(BuildContext context, int permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          title: AppLargeText(
              text: permission == 0
                  ? 'Uyarı! İşletmeden ayrılmak mı istiyorsunuz?'
                  : 'Uyarı! İşletmeyi kapatmak mı istiyorsunuz?'),
          content: AppText(
            text: permission == 0
                ? 'Eğer bu işlemi gerçekleştirirseniz, işletmenizden ayrılacak ve bu adım geri alınamaz olacaktır. Bu nedenle, lütfen bu kararı dikkatlice düşünün ve işletmenizle ilgili tüm bilgileri kaydedip yedekleyerek emin olun.'
                : 'İşletmenizi kapatmak, tüm faaliyetlerinizi durduracak ve bu işlem geri alınamaz olacaktır. Kapatma işlemi sonrasında, işletmenize ait verilere ve bilgilere erişim kaybolacak, ve bu süreci geri almak mümkün olmayacaktır.',
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
              onPressed: _leaveCompany,
              child: AppText(
                text: 'Ayrılmak İstiyorum!',
                color: AppTheme.alertRed[0],
              ),
            ),
          ],
        );
      },
    );
  }

  Future _leaveCompany() async {
    bool answer =
        await Shop.shop_leaveCompany(token: Shop.selectedShop!.shop_id);
    print(answer);
    if (answer) {
      Navigator.of(context).pop();
      widget.updatePage!(pageId: 94);
    } else {}
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
                        width: double.maxFinite,
                        padding: EdgeInsets.only(
                            top: getPaddingScreenTopHeight() +
                                paddingHorizontal),
                        child: ListView(
                          shrinkWrap: true,
                          padding: paddingZero,
                          children: [
                            Box_View(
                              boxInside: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: paddingHorizontal),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: User.userProfile!
                                                    .userProfilePhoto)),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: paddingHorizontal),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        paddingHorizontal / 2),
                                                child: AppText(
                                                  text:
                                                      '${User.userProfile!.userName}',
                                                  fontWeight: FontWeight.bold,
                                                  size: 16,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        paddingHorizontal / 2),
                                                child: AppText(
                                                  text:
                                                      '${Shop.selectedShop!.shop_name}',
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                              AppText(
                                                text:
                                                    'İşletmeyi Değiştmek İçin Tıklayın',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Shop.invitedShops.isNotEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        builder: (builder) {
                                          return Invited_Shops();
                                        },
                                      );
                                    },
                                    child: Box_View(
                                        boxInside: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text:
                                                    '${Shop.invitedShops.length} işletme seni işletmesine davet ediyor!',
                                                fontWeight: FontWeight.bold,
                                                size: 13,
                                              ),
                                              AppText(
                                                  text:
                                                      'Olan bir işletme seni bünyesine katmak istiyor! Hemen gözat!'),
                                            ],
                                          ),
                                        ),
                                        FaIcon(FontAwesomeIcons.box,
                                            color: AppTheme.textColor)
                                      ],
                                    )),
                                  )
                                : Container(),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text: 'Kişisel Ayarlar',
                                      fontWeight: FontWeight.bold,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                    ),
                                  ),
                                  SettingsButton(
                                    buttonName: 'Profilim',
                                    buttonOnclick: () {
                                      widget.updatePage!(pageId: 31);
                                    },
                                  ),
                                  SettingsButton(
                                    buttonName: 'Profilimi Düzenle',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Hesap Gizliliği',
                                    buttonOnclick: () {},
                                  ),
                                ],
                              ),
                            ),
                            Shop.selectedShop!.shopPermissions
                                        .shop_can_add_teammates &&
                                    Shop.selectedShop!.userPermissionLevel != 0
                                ? Box_View(
                                    boxInside: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: paddingHorizontal),
                                          child: AppText(
                                            text: 'İşletme Ayarları',
                                            fontWeight: FontWeight.bold,
                                            size: 15,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: paddingHorizontal),
                                          child: AppText(
                                            text:
                                                'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                          ),
                                        ),
                                        SettingsButton(
                                          buttonName: 'İşletme Görünürlük',
                                          buttonOnclick: () {},
                                        ),
                                        SettingsButton(
                                          buttonName: 'İşletme Ayarlar',
                                          buttonOnclick: () {},
                                        ),
                                        SettingsButton(
                                          buttonName: 'Takım Arkadaşlarım',
                                          buttonOnclick: () {},
                                        ),
                                        SettingsButton(
                                          buttonName: 'Müşteriler',
                                          buttonOnclick: () {},
                                        ),
                                        SettingsButton(
                                          buttonName:
                                              'İşletmenizin Satın Almaları',
                                          buttonOnclick: () {},
                                        ),
                                        SettingsButton(
                                          buttonName:
                                              'İşletmenizin Servis Alanlarını Tekrar Oluştur',
                                          buttonOnclick: () {},
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            /* Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text: 'İşletme İletişim',
                                      fontWeight: FontWeight.bold,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                    ),
                                  ),
                                  SettingsButton(
                                    buttonName: 'İşletmeye Gönderilen Mesajlar',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'İşletmenizi Etiketleyenler',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'İşletmenize Gelen Yorumlar',
                                    buttonOnclick: () {},
                                  ),
                                ],
                              ),
                            ),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text: 'Websitesi Ayarları',
                                      fontWeight: FontWeight.bold,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                    ),
                                  ),
                                  SettingsButton(
                                    buttonName:
                                        'Kurumsal Websitenizi Ayarları Düzenle',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName:
                                        'Kurumsal Websitenizi Düzenleyin',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName:
                                        'Menü Websitenizin Ayarlarını Düzenleyin',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName:
                                        'Menü Websitesinin Görünürlük Düzenleyin',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Menü Websitesini Düzenleyin',
                                    buttonOnclick: () {},
                                  ),
                                ],
                              ),
                            ),
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text: 'Platform Ayarları',
                                      fontWeight: FontWeight.bold,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                    ),
                                  ),
                                  SettingsButton(
                                    buttonName: 'Platformlara Göre Görünürlük',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Platform Ayarları',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName:
                                        'Platformlara Göre Ürünlerini Düzenle',
                                    buttonOnclick: () {},
                                  ),
                                ],
                              ),
                            ),
                             */
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text: 'Uygulama Ayarları',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'İşletmenizin son ayarlamalarını buradan yapabilir, müşterilerinize daha kaliteli bir deneyim sunabilirsiniz.',
                                    ),
                                  ),
                                  SettingsButton(
                                    buttonName: 'Görünüm Ayarları',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Gizlilik Ayarları',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Bildirim Ayarları',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Data-Saver',
                                    buttonOnclick: () {},
                                  ),
                                  SettingsButton(
                                    buttonName: 'Dil',
                                    buttonOnclick: () {},
                                  ),
                                ],
                              ),
                            ),
                            Shop.attendedShops.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      if (Shop.attendedShops.isNotEmpty) {
                                        widget.updatePage!(pageId: 94);
                                      }
                                    },
                                    child: Box_View(
                                      color: AppTheme.alertYellow[0]
                                          .withOpacity(.4),
                                      boxInside: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.share,
                                                size: 14,
                                                color: AppTheme.textColor,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        paddingHorizontal / 2),
                                                child: AppText(
                                                  text: 'İşletme Değiştir',
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.angleRight,
                                            size: 14,
                                            color: AppTheme.textColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                _showAlertDialogQuitCompany(context,
                                    Shop.selectedShop!.userPermissionLevel!);
                              },
                              child: Box_View(
                                color: AppTheme.alertRed[0].withOpacity(.4),
                                boxInside: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.x,
                                          size: 14,
                                          color: AppTheme.textColor,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: paddingHorizontal / 2),
                                          child: AppText(
                                            text: 'Kuruluştan Ayrıl',
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.angleRight,
                                      size: 14,
                                      color: AppTheme.textColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            '${Shop.selectedShop!.shop_owner_Id}' ==
                                    User.userProfile!.userId
                                ? GestureDetector(
                                    onTap: () {},
                                    child: Box_View(
                                      color:
                                          AppTheme.alertRed[0].withOpacity(.4),
                                      boxInside: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.x,
                                                size: 14,
                                                color: AppTheme.textColor,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        paddingHorizontal / 2),
                                                child: AppText(
                                                  text: 'Kuruluşu Kapat',
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          FaIcon(
                                            FontAwesomeIcons.angleRight,
                                            size: 14,
                                            color: AppTheme.textColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Box_View(
                              color: AppTheme.alertRed[0].withOpacity(.4),
                              boxInside: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.x,
                                        size: 14,
                                        color: AppTheme.textColor,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: paddingHorizontal / 2),
                                        child: AppText(
                                          text: 'Hesaptan Çıkış Yap',
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.angleRight,
                                    size: 14,
                                    color: AppTheme.textColor,
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
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.buttonName,
    this.buttonIcon,
    required this.buttonOnclick,
  });

  final String buttonName;
  final IconData? buttonIcon;
  final Function buttonOnclick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => buttonOnclick(),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.textColor.withOpacity(.4)),
            top: BorderSide(color: AppTheme.textColor.withOpacity(.4)),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                buttonIcon != null
                    ? FaIcon(
                        buttonIcon,
                        size: 14,
                        color: AppTheme.textColor,
                      )
                    : Container(),
                AppText(
                  text: buttonName,
                  size: 14,
                ),
              ],
            ),
            FaIcon(
              FontAwesomeIcons.angleRight,
              size: 14,
              color: AppTheme.textColor,
            )
          ],
        ),
      ),
    );
  }
}
