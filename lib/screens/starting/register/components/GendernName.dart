import 'package:envanterimservetim/core/constants/stringConstans.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/register/components/genderButtons.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenderWidget extends StatefulWidget {
  const GenderWidget({super.key, required this.nextPage});

  final Function nextPage;

  @override
  State<GenderWidget> createState() => _GenderWidgetState();
}

class _GenderWidgetState extends State<GenderWidget> {
  String kullanici_isim = '', kullanici_soyad = '', gender = '';
  List<String> errorMessage = [];
  bool showError = false, showNextbutton = false;

  void checkNextpage() {
    errorMessage = [];
    if (kullanici_isim == '') {
      errorMessage.add(trNamelNullError);
    }

    if (kullanici_soyad == '') {
      errorMessage.add(trSurnamelNullError);
    }
    if (gender == '') {
      errorMessage.add(trGenderNullError);
    }

    if (errorMessage.length == 0) {
      setState(() {
        showNextbutton = true;
      });
    } else {
      setState(() {
        showError = true;
      });
    }
    print(errorMessage.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLargeText(
            text: 'Hoşgeldiniz!',
            color: AppTheme.background,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: AppText(
              text:
                  "Şehir Kılavuzu'na hoş geldin! Şehirlerin gizli hazinelerini keşfetmeye ve unutulmaz deneyimlere adım atmaya hazır mısın? Kayıt ol, uygulamamızın sunduğu eşsiz içeriklere, etkinliklere ve mekanlara kolayca ulaş. ",
              color: AppTheme.background,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: AppText(
              text: "Sizlere Nasıl Hitap Edebiliriz? ",
              color: AppTheme.background,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.background)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextField(
                      onChanged: (isim) {
                        setState(() {
                          kullanici_isim = isim;
                        });
                        print(kullanici_isim);
                      },
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "İsminiz",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.firstColor.withOpacity(.3))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.firstColor.withOpacity(1))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.background)),
                    child: TextField(
                      onChanged: (soyisim) {
                        setState(() {
                          kullanici_soyad = soyisim;
                        });
                        print(kullanici_soyad);
                      },
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Soyisminiz",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.firstColor.withOpacity(.3))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.firstColor.withOpacity(1))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GenderButtons(
              insideText: 'Hanımefendi',
              selected: gender == 'her',
              widgetFunction: () {
                setState(() {
                  gender = 'her';
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GenderButtons(
              insideText: 'Beyfendi',
              selected: gender == 'his',
              widgetFunction: () {
                setState(() {
                  gender = 'his';
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GenderButtons(
              insideText: 'Belirtmek İstemiyorum',
              selected: gender == 'nonbinary',
              widgetFunction: () {
                setState(() {
                  gender = 'nonbinary';
                });
              },
            ),
          ),
          showError
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: errorMessage.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.xmarkCircle,
                              color: AppTheme.alertRed[0],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: AppText(
                                text: errorMessage[index],
                                color: AppTheme.alertRed[0],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: () {
              setState(() {
                showError = false;
              });
              checkNextpage();

              if (showNextbutton) {
                widget.nextPage(kullanici_isim, gender);
              }
            },
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppTheme.firstColor,
                  border: Border.all(color: AppTheme.firstColor)),
              child: AppText(
                text: 'Devam Et',
                color: AppTheme.background,
              ),
            ),
          )
        ],
      ),
    );
  }
}
