import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AdsOfApp extends StatefulWidget {
  const AdsOfApp({super.key});

  @override
  State<AdsOfApp> createState() => _AdsOfAppState();
}

class _AdsOfAppState extends State<AdsOfApp> {
  List selectedPackages = [];
  bool isProcessing = false, isBought = false;
  PageController? _pageController;
  int initialPages = 0;
  DateTime now = DateTime.now().add(Duration(days: 30));
  String? formattedDate;

  Future<void> extendPackage() async {
    setState(() {
      isProcessing = true;
    });
    bool dance = await Shop.shop_buyPackage(selectedPackages, formattedDate!);

    setState(() {
      isBought = dance;
      _pageController!.jumpToPage(1);
    });
  }

  @override
  void initState() {
    setState(() {
      formattedDate = DateFormat('dd/MM/yyyy').format(now);
    });
    _pageController = PageController(initialPage: initialPages);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .8,
      maxChildSize: 1,
      builder: (_, controller) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: getPaddingScreenBottomHeight(),
          ),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListView(
                    shrinkWrap: true,
                    controller: controller,
                    padding: paddingZero,
                    children: [
                      NetworkContainer(
                        imageUrl: NetworkImage(
                            'https://images.pexels.com/photos/4483610/pexels-photo-4483610.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                        child: Container(
                          width: double.maxFinite,
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppTheme.background,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: selectedPackages.isNotEmpty
                            ? EdgeInsets.only(
                                bottom: paddingHorizontal * 3 + 14)
                            : paddingZero,
                        padding: EdgeInsets.all(paddingHorizontal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: paddingHorizontal),
                              child: AppText(
                                text:
                                    'İşletmenizi Zirveye Taşıyın, Stokları ve Geliri Optimize Edin!',
                                fontWeight: FontWeight.bold,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: paddingHorizontal),
                              child: AppText(
                                text:
                                    'İşletmenizin isteklerine göre planınızı şekillendirin!',
                                fontWeight: FontWeight.bold,
                                size: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: paddingHorizontal),
                              child: const App_Rich_Text(
                                text: [
                                  'Envanterim İş Hayatım, işletmenizi daha ',
                                  'akıllı ve etkili',
                                  ' bir şekilde yönetmeniz için tasarlanmış güçlü bir uygulamadır. Stokları anlık olarak takip edin, satışları ',
                                  'optimize edin ve gelirinizi artırın',
                                  '. Kullanıcı dostu arayüzü ile hızlı ve kolay veri girişi yapın. ',
                                  'Ürün kategorileri oluşturun, tedarikçi bilgilerinizi kaydedin ve işletmenize özel kampanya ve indirimleri yönetin.',
                                  ' İşletmenizin performansını detaylı raporlar ve istatistiklerle analiz edin. Envanterim İş Hayatım ile işletmenizin başarısına yeni bir boyut katın!'
                                ],
                                size: 14,
                                maxLineCount: 999,
                              ),
                            ),
                            Shop.selectedShop!.userPermissionLevel != 0
                                ? isProcessing
                                    ? Center(
                                        child: Container(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      ))
                                    : GridView.count(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        crossAxisSpacing: paddingHorizontal,
                                        mainAxisSpacing: paddingHorizontal,
                                        childAspectRatio: .75,
                                        crossAxisCount: 2,
                                        children: <Widget>[
                                          AddPackages(
                                            onTap: () {
                                              if (!Shop
                                                  .selectedShop!
                                                  .shopPermissions
                                                  .shop_can_add_teammates) {
                                                setState(() {
                                                  if (selectedPackages.contains(
                                                      'user_control')) {
                                                    selectedPackages
                                                        .remove('user_control');
                                                  } else {
                                                    selectedPackages
                                                        .add('user_control');
                                                  }
                                                });
                                              }
                                            },
                                            isSelected: (Shop
                                                    .selectedShop!
                                                    .shopPermissions
                                                    .shop_can_add_teammates ||
                                                selectedPackages
                                                    .contains('user_control')),
                                            packageIcon: FontAwesomeIcons.user,
                                            packageTitle: 'Çalışan Paketi',
                                            packageText:
                                                'Çalışanlarınız ile birlikte işletmenizi daha kolay yönetin!',
                                            packageIsOwned: Shop
                                                .selectedShop!
                                                .shopPermissions
                                                .shop_can_add_teammates,
                                            packagePrice: 149.00,
                                          ),
                                          AddPackages(
                                            onTap: () {
                                              if (!Shop
                                                  .selectedShop!
                                                  .shopPermissions
                                                  .shop_can_bill) {
                                                setState(() {
                                                  if (selectedPackages
                                                      .contains('payout')) {
                                                    selectedPackages
                                                        .remove('payout');
                                                  } else {
                                                    selectedPackages
                                                        .add('payout');
                                                  }
                                                });
                                              }
                                            },
                                            isSelected: (Shop
                                                    .selectedShop!
                                                    .shopPermissions
                                                    .shop_can_bill ||
                                                selectedPackages
                                                    .contains('payout')),
                                            packageIcon:
                                                FontAwesomeIcons.fileInvoice,
                                            packageTitle: 'Fatura Paketi',
                                            packageText:
                                                'Faturalarını uygulama üzerinden anında kesmek ister misin?',
                                            packageIsOwned: Shop.selectedShop!
                                                .shopPermissions.shop_can_bill,
                                            packagePrice: 149.00,
                                          ),
                                          AddPackages(
                                            onTap: () {
                                              if (!Shop
                                                  .selectedShop!
                                                  .shopPermissions
                                                  .shop_can_init_reminder) {
                                                setState(() {
                                                  if (selectedPackages.contains(
                                                      'inventory_upgrade')) {
                                                    selectedPackages.remove(
                                                        'inventory_upgrade');
                                                  } else {
                                                    selectedPackages.add(
                                                        'inventory_upgrade');
                                                  }
                                                });
                                              }
                                            },
                                            isSelected: (Shop
                                                    .selectedShop!
                                                    .shopPermissions
                                                    .shop_can_init_reminder ||
                                                selectedPackages.contains(
                                                    'inventory_upgrade')),
                                            packageIcon: FontAwesomeIcons.box,
                                            packageTitle: 'Envanter Paketi',
                                            packageText:
                                                'Envanter Paketi ile birlikte envanterini daha rahat kontrol et!',
                                            packageIsOwned: Shop
                                                .selectedShop!
                                                .shopPermissions
                                                .shop_can_init_reminder,
                                            packagePrice: 149.00,
                                          ),
                                          AddPackages(
                                            onTap: () {
                                              if (!Shop
                                                  .selectedShop!
                                                  .shopPermissions
                                                  .shop_can_see_analytics) {
                                                setState(() {
                                                  if (selectedPackages
                                                      .contains('analytics')) {
                                                    selectedPackages
                                                        .remove('analytics');
                                                  } else {
                                                    selectedPackages
                                                        .add('analytics');
                                                  }
                                                });
                                              }
                                            },
                                            isSelected: (Shop
                                                    .selectedShop!
                                                    .shopPermissions
                                                    .shop_can_see_analytics ||
                                                selectedPackages
                                                    .contains('analytics')),
                                            packageIcon:
                                                FontAwesomeIcons.chartPie,
                                            packageTitle: 'Analiz Paketi',
                                            packageText:
                                                'Günlük, Haftalık ve Aylık analizlere ne dersin?',
                                            packageIsOwned: Shop
                                                .selectedShop!
                                                .shopPermissions
                                                .shop_can_see_analytics,
                                            packagePrice: 149.00,
                                          ),
                                        ],
                                      )
                                : Container(
                                    height: 250,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppTheme.background1,
                                        borderRadius: BorderRadius.circular(
                                            paddingHorizontal)),
                                    padding: EdgeInsets.all(paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'Satın Alımlar İçin Yetkiniz Bulunmamaktadır. \nLütfen Yetkili Birisi İle Görüşünüz!',
                                      size: 18,
                                      align: TextAlign.center,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                  selectedPackages.isNotEmpty
                      ? GestureDetector(
                          onTap: extendPackage,
                          child: Container(
                            padding: EdgeInsets.all(paddingHorizontal),
                            margin: EdgeInsets.only(
                                bottom: getPaddingScreenBottomHeight() +
                                    paddingHorizontal / 2,
                                left: paddingHorizontal,
                                right: paddingHorizontal),
                            decoration: BoxDecoration(
                                color: AppTheme.contrastColor1,
                                borderRadius: defaultRadius),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLargeText(text: 'Şimdi Üyeliğimi Genişlet'),
                                AppLargeText(
                                    text:
                                        '${selectedPackages.length * 149} ₺ / Aylık')
                              ],
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Comfirmation(
                isOkay: isBought,
              )
            ],
          ),
        );
      },
    );
  }
}

class Comfirmation extends StatefulWidget {
  const Comfirmation({
    super.key,
    required this.isOkay,
  });
  final bool isOkay;

  @override
  State<Comfirmation> createState() => _ComfirmationState();
}

class _ComfirmationState extends State<Comfirmation> {
  DateTime now = DateTime.now().add(Duration(days: 30));
  String? formattedDate;
  @override
  void initState() {
    setState(() {
      formattedDate = DateFormat('dd/MM/yyyy').format(now);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: widget.isOkay
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(paddingHorizontal),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.alertGreen[0]),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    color: AppTheme.alertGreen[0],
                    size: 45,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: AppLargeText(
                        text: 'Ödemeniz Başarılı Bir Şekilde Tamamlanmıştır.',
                        align: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: AppText(
                        text:
                            'Ödemeniz başarılı bir şekilde tamamlandı! Bizimle iş yapmayı tercih ettiğiniz için teşekkür ederiz. Siparişiniz en kısa sürede işleme alınacak ve tarafınıza ulaştırılacaktır. Başka bir konuda size yardımcı olabileceğimiz bir şey varsa, lütfen bize bildirin. İyi günlerde kullanmanızı dileriz!',
                        align: TextAlign.center,
                        maxLineCount: 99,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: AppText(
                        text: 'Yenilenme Tarihi : ${formattedDate}',
                        align: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(paddingHorizontal),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1,
                            borderRadius: defaultRadius),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Uygulamaya Geri Dön',
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowRight,
                              color: AppTheme.textColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(paddingHorizontal),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.alertRed[0]),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    color: AppTheme.alertRed[0],
                    size: 45,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: AppLargeText(
                        text: 'Ödemeniz Başarısız olmuştur.',
                        align: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: paddingHorizontal),
                      child: AppText(
                        text:
                            'Ödemeniz maalesef başarısız olmuştur. Lütfen kredi kartı bilgilerinizi kontrol edip tekrar deneyin. Eğer sorun devam ederse, bankanızla iletişime geçerek durumu bildiriniz. Başka bir ödeme yöntemi tercih etmek isterseniz veya başka bir konuda yardımımıza ihtiyacınız olursa, bize ulaşmaktan çekinmeyin. Size daha iyi hizmet verebilmek için elimizden geleni yapacağız. Teşekkür ederiz.',
                        align: TextAlign.center,
                        maxLineCount: 99,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(paddingHorizontal),
                        decoration: BoxDecoration(
                            color: AppTheme.contrastColor1,
                            borderRadius: defaultRadius),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Uygulamaya Geri Dön',
                              align: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),
                            FaIcon(
                              FontAwesomeIcons.arrowRight,
                              color: AppTheme.textColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}

class AddPackages extends StatelessWidget {
  const AddPackages({
    super.key,
    required this.packageIcon,
    required this.packageTitle,
    required this.packageText,
    required this.packageIsOwned,
    required this.packagePrice,
    required this.isSelected,
    required this.onTap,
  });
  final IconData packageIcon;
  final String packageTitle, packageText;
  final bool packageIsOwned, isSelected;
  final double packagePrice;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(paddingHorizontal),
        decoration: BoxDecoration(
          color: AppTheme.background1,
          border:
              isSelected ? Border.all(color: AppTheme.contrastColor4) : null,
          borderRadius: defaultRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(paddingHorizontal),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.contrastColor4),
                shape: BoxShape.circle,
              ),
              child:
                  FaIcon(packageIcon, size: 36, color: AppTheme.contrastColor4),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: packageTitle,
                    fontWeight: FontWeight.bold,
                    size: 14,
                    align: TextAlign.center,
                  ),
                  AppText(
                    text: packageText,
                    fontStyle: FontStyle.italic,
                    align: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.all(paddingHorizontal / 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.contrastColor4),
                      color: packageIsOwned ? AppTheme.contrastColor4 : null,
                      borderRadius: defaultRadius,
                    ),
                    child: AppText(
                        color: packageIsOwned ? Colors.black : null,
                        text: packageIsOwned
                            ? 'Zaten Sahipsiniz'
                            : '₺ $packagePrice / Aylık'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAdsOfApp(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return AdsOfApp();
    },
  );
}
