import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Invited_Shops extends StatelessWidget {
  const Invited_Shops({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .65,
      maxChildSize: .9,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(paddingHorizontal))),
          width: double.maxFinite,
          padding: EdgeInsets.only(
              top: paddingHorizontal, bottom: getPaddingScreenBottomHeight()),
          child: ListView(
            controller: controller,
            shrinkWrap: true,
            children: [
              Box_View(
                  boxInside: AppLargeText(
                      text: 'Bazı İşletmeler Seni Bünyelerine Katmak İstiyor')),
              Box_View(
                //TODO açıklama yaz
                boxInside: AppText(
                  text:
                      'Aşağıdaki birimlerden birisini seçerek ürününüzün birimini belirleyebilirsiniz, böylece siparişlerinizi daha etkili ve düzenli bir şekilde yönetebilirsiniz. Seçilen birim, ürün fiyatlandırması, stok takibi ve diğer işlemler için temel bir referans noktası olacaktır. Doğru bir birim seçimi, iş süreçlerinizi optimize etmenize ve müşterilerinize daha iyi hizmet sunmanıza yardımcı olacaktır',
                  maxLineCount: 10,
                ),
              ),
              ListView.builder(
                itemCount: Shop.invitedShops.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  print(Shop.invitedShops.length);
                  Shop invitedShop = Shop.invitedShops[index];
                  return Invitation(invitedShop: invitedShop);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Invitation extends StatefulWidget {
  const Invitation({
    super.key,
    required this.invitedShop,
  });

  final Shop invitedShop;

  @override
  State<Invitation> createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> {
  bool isAnswered = true, isOkay = false;

  Future _setAnswer() async {
    bool answer = await Shop.shop_answerInvitation(
        token: widget.invitedShop.shop_id, answer: isOkay);
    print(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: isAnswered
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: NetworkContainer(
                    imageUrl: widget.invitedShop.shop_image,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: paddingHorizontal),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'İşletmenin İsimi',
                              fontWeight: FontWeight.bold,
                            ),
                            AppText(
                              text: '${widget.invitedShop.shop_name}',
                            ),
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: paddingHorizontal),
                          child: App_Rich_Text(
                            text: [
                              'Yukarıda belirtilen işletme sizi davet etmiştir. Eğer bu işletmenin envanter sayfasına katılmak istiyorsanız ',
                              'Katıl',
                              ' düğmesine basabilir, katılmak istemiyorsanız ',
                              'Reddet',
                              ' düğmesine basabilirsiniz.'
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOkay = true;
                                    isAnswered = false;
                                  });
                                  _setAnswer();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: paddingHorizontal * .5),
                                  padding: EdgeInsets.all(paddingHorizontal),
                                  decoration: BoxDecoration(
                                      color: AppTheme.alertGreen[0],
                                      borderRadius: BorderRadius.circular(
                                          paddingHorizontal)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Katıl',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isOkay = false;
                                    isAnswered = false;
                                  });
                                  _setAnswer();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: paddingHorizontal * .5),
                                  padding: EdgeInsets.all(paddingHorizontal),
                                  decoration: BoxDecoration(
                                      color: AppTheme.alertRed[0],
                                      borderRadius: BorderRadius.circular(
                                          paddingHorizontal)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppText(
                                        text: 'Reddet',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.x,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(
              child: AppLargeText(
                text: isOkay
                    ? "Artık '${widget.invitedShop.shop_name}' işletmesinin bünyesinde yer almaktasınız."
                    : 'Cevabınız işletmeye bildirilmiştir.',
                align: TextAlign.center,
              ),
            ),
    );
  }
}
