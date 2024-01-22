import 'package:envanterimservetim/core/constants/stringConstans.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MailandPassword extends StatefulWidget {
  const MailandPassword({
    super.key,
    required this.kullanici_adsoyad,
    required this.nextPage,
  });

  final String kullanici_adsoyad;
  final Function nextPage;

  @override
  State<MailandPassword> createState() => _MailandPasswordState();
}

class _MailandPasswordState extends State<MailandPassword> {
  bool showPassword = true, termsAccepted = false, showError = false;
  String kullanici_mail = '', kullanici_gsm = '', kullanici_sifre = '';
  PageController _pageController = PageController();
  List<String> errorMessage = [];

  void checkAvalibilty() {
    errorMessage = [];
    if (!termsAccepted) {
      errorMessage.add(trTermsNullError);
    } else {
      //email Kontrolü
      if (kullanici_mail == '') {
        errorMessage.add(trEmailNullError);
      } else {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(kullanici_mail);
        if (!emailValid) {
          errorMessage.add(trInvalidEmailError);
        }
      }

      //sifre kontorlü
      if (kullanici_sifre == '') {
        errorMessage.add(trPassNullError);
      } else {
        if (kullanici_sifre.length < 6) {
          errorMessage.add(trShortPassError);
        }
      }

      //telefon Kontrolü
      if (kullanici_gsm == '') {
        errorMessage.add(trPhoneNumberNullError);
      } else {
        if (kullanici_gsm.length != 10) {
          errorMessage.add(trIvalidPhoneNumberError);
        }
      }
    }

    if (errorMessage.length > 0) {
      setState(() {
        showError = true;
      });
    } else {
      widget.nextPage(kullanici_mail, kullanici_gsm, kullanici_sifre);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLargeText(
            text: 'Çok Güzel!',
            color: AppTheme.background,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: AppText(
              text:
                  'İlk adımı tamamladık ${widget.kullanici_adsoyad}! Şimdi sırada sana daha iyi ulaşabilmemiz için senin iletişim bilgilerine ihtiyacımız var!',
              color: AppTheme.background,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration:
                BoxDecoration(border: Border.all(color: AppTheme.background)),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TextField(
              onChanged: (email) {
                setState(() {
                  kullanici_mail = email;
                });
              },
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email Adresiniz",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(.3))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(1))),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration:
                BoxDecoration(border: Border.all(color: AppTheme.background)),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TextField(
              onChanged: (gsm) {
                setState(() {
                  kullanici_gsm = gsm;
                });
              },
              style: TextStyle(fontSize: 16, color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Telefon Numaranız",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixText: '+90 ',
                filled: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(.3))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(1))),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration:
                BoxDecoration(border: Border.all(color: AppTheme.background)),
            padding: EdgeInsets.symmetric(vertical: 15),
            child: TextField(
              obscureText: showPassword,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (sifre) {
                setState(() {
                  kullanici_sifre = sifre;
                });
              },
              style: TextStyle(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                hintText: "Şifreniz",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(.3))),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.firstColor.withOpacity(1))),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!termsAccepted) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return TermsModal(context);
                  },
                );
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              decoration:
                  BoxDecoration(border: Border.all(color: AppTheme.background)),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: termsAccepted
                        ? FaIcon(
                            FontAwesomeIcons.check,
                            color: AppTheme.background,
                          )
                        : FaIcon(
                            FontAwesomeIcons.xmark,
                            color: AppTheme.background,
                          ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                        child: AppText(
                      text:
                          'Gizlilik Sözleşmesini, Haklar ve Yükümlülükler Sözleşmesini Kabul Ediyorum',
                      color: AppTheme.background,
                    )),
                  ),
                ],
              ),
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
                            Expanded(
                              flex: 1,
                              child: FaIcon(
                                FontAwesomeIcons.xmarkCircle,
                                color: AppTheme.alertRed[0],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                child: AppText(
                                  text: errorMessage[index],
                                  color: AppTheme.alertRed[0],
                                ),
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
              checkAvalibilty();
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
          ),
        ],
      ),
    );
  }

  Container TermsModal(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(
          top: getPaddingScreenTopHeight(),
          bottom: getPaddingScreenBottomHeight()),
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: AppLargeText(text: 'Gizlilik Sözleşmesi'),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: ListView(
                    padding: paddingZero,
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: AppText(
                          text: privacyPolicy,
                          maxLineCount: 999999,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _pageController.nextPage(
                          duration: defaultDuration, curve: Curves.easeInOut);
                    },
                    child: Container(
                      width: double.maxFinite,
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: AppLargeText(text: 'Haklar ve Koşullar'),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: ListView(
                    padding: paddingZero,
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: AppText(
                          text: privacyPolicy,
                          maxLineCount: 999999,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        termsAccepted = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.maxFinite,
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
