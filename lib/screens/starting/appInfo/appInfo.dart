import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppInfo extends StatefulWidget {
  final AnimationController? animationController;
  final Function? updatePage;
  const AppInfo({Key? key, this.animationController, this.updatePage})
      : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  Animation? animation;
  List deneme = [
    'Yeni şehirlerin gizemli sokaklarında kaybolmaya ne dersin? Şehir Kılavuzu ile keşfetmeye hazırsan, sana unutulmaz bir seyahat deneyimi sunuyoruz! Her şehirde farklı bir hikaye var ve sen de bu hikayenin bir parçası olabilirsin.',
    'Şehirlerin geçmişine yolculuk yapmaya ne dersin? Yüzlerce yıllık tarih ve renkli kültürlerle dolu şehirleri keşfetmeye davetlisin. Unutulmaz anılar biriktirmek için bu benzersiz deneyimleri kaçırma!',
    'Ünlü turistik mekanların yanı sıra sıra dışı rotalara da açılmaya ne dersin? Şehir Kılavuzu ile keşfedeceğin yerler arasında tarihi kaleler, nefes kesen manzaralar ve doğal güzellikler var. İster klasik turistik rotaları takip et, ister kendi özel rotalarını oluştur!',
    'Seyahatinde lezzet dolu bir yolculuğa çıkmak ister misin? Yöresel lezzetlerden uluslararası mutfaklara kadar damak tadına uygun birçok seçenek seni bekliyor. Geleneksel yemekleri tat, yeni serüvene çık!',
    "Seyahat planlama süreci artık daha kolay! Gezi rotaları, online rezervasyonlar ve daha fazlası ile seyahatlerinizi organize etmek Şehir Kılavuzu'nda mümkün. İstediğin restoranlara, etkinliklere ve gezilecek yerlere online olarak ulaşabilir",
    "Seyahat deneyimlerini paylaşma zamanı geldi! Sosyal medya özelliğiyle seyahatlerinizi anında paylaşabilir, arkadaşlarınıza ilham verebilirsiniz. Şehir Kılavuzu'nda edindiğiniz eşsiz deneyimleri fotoğraflarla ve hikayelerle paylaşarak diğer gezginlere ilham olun!"
  ];

  List deneme_title = [
    'Keşfetmeye Hazır mısın?',
    'Yerel Kültür ve \nTarihle Tanışın',
    'Turistik Mekanlar ve \nGizli Cennetler',
    'Lezzet Dolu Bir \nYolculuğa Çıkın ',
    'Seyahatinizi Planlayın, Kolayca Gerçekleştirin',
    'Deneyimlerinizi Paylaşın ve İlham Verin'
  ];

  @override
  void initState() {
    animation =
        Tween<double>(begin: 0, end: 1).animate(widget.animationController!);
    widget.animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) {
        return Opacity(
          opacity: animation!.value,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: deneme.length,
              itemBuilder: (context, index) {
                return TripleWidget(
                  oncontrollerChange: () {
                    if (index == deneme.length - 1) {
                      SharedPref.addBoolToSF(isShownWelcomeInfos, true);
                      widget.updatePage!(pageId: 92);
                    }

                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        index + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  assetImg: 'assets/welcome/icon_${index + 1}.png',
                  welcomeSub: deneme[index],
                  welcomeTitle: deneme_title[index],
                  totalCount: deneme.length,
                  currentIndex: index,
                  buttonName:
                      index != (deneme.length - 1) ? 'Devam Et' : 'Giriş Yap',
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class TripleWidget extends StatefulWidget {
  final Function? oncontrollerChange;
  final String? assetImg;
  final String? welcomeTitle;
  final String? welcomeSub;
  final int? totalCount;
  final int? currentIndex;
  final String? buttonName;
  const TripleWidget(
      {Key? key,
      this.oncontrollerChange,
      this.assetImg,
      this.currentIndex,
      this.totalCount,
      this.buttonName,
      this.welcomeSub,
      this.welcomeTitle})
      : super(key: key);

  @override
  State<TripleWidget> createState() => _TripleWidgetState();
}

class _TripleWidgetState extends State<TripleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: 80, bottom: 40, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      widget.assetImg ?? 'assets/welcome/icon_2.png'),
                  fit: BoxFit.contain),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25, bottom: 15),
                child: AppLargeText(
                  text: '${widget.welcomeTitle}',
                  color: Colors.black,
                  align: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 15, bottom: 25),
                child: AppText(
                  text: '${widget.welcomeSub}',
                  color: Colors.black,
                  align: TextAlign.center,
                  maxLineCount: 6,
                ),
              ),
              Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                height: 20,
                child: ListView.builder(
                  itemCount: widget.totalCount,
                  shrinkWrap: true,
                  padding: paddingZero,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 4),
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: index <= widget.currentIndex!
                                ? Colors.black
                                : Colors.white),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.oncontrollerChange!();
            },
            child: Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppTheme.firstColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: '${widget.buttonName}',
                    color: Colors.white,
                    size: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
