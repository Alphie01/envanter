import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/starting/loading/components/logoContainer.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GSOP_Mail_Comfirmation extends StatefulWidget {
  const GSOP_Mail_Comfirmation({
    super.key,
    required this.fetchedMap,
    required this.updatePage,
  });
  final Map<String, dynamic> fetchedMap;
  final Function updatePage;
  @override
  State<GSOP_Mail_Comfirmation> createState() => _GSOP_Mail_ComfirmationState();
}

class _GSOP_Mail_ComfirmationState extends State<GSOP_Mail_Comfirmation> {
  FocusNode _focusNode = FocusNode(),
      _focusNode1 = FocusNode(),
      _focusNode2 = FocusNode(),
      _focusNode3 = FocusNode();

  TextEditingController _editingController = TextEditingController(),
      _editingController1 = TextEditingController(),
      _editingController2 = TextEditingController(),
      _editingController3 = TextEditingController();

  bool error = false, loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setFocus(int hasFocused) {
    switch (hasFocused) {
      case 0:
        FocusScope.of(context).requestFocus(_focusNode);
        break;
      case 1:
        FocusScope.of(context).requestFocus(_focusNode1);
        break;
      case 2:
        FocusScope.of(context).requestFocus(_focusNode2);
        break;
      case 3:
        FocusScope.of(context).requestFocus(_focusNode3);
        break;
      default:
        FocusScope.of(context).requestFocus(_focusNode);
    }
  }

  String mailKey() {
    return _editingController.text +
        _editingController1.text +
        _editingController2.text +
        _editingController3.text;
  }

  Future isEmailOkay() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> data = widget.fetchedMap;
    data['check_mail_key'] = 'ok';
    data['mail_key'] = mailKey();
    bool dance = await User.chekMailKey(data);
    if (dance) {
      widget.updatePage();
    } else {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }

  Future resendMail() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> data = {
      'resend_mail_key': 'ok',
      'kullanici_mail': widget.fetchedMap['kullanici_mail'],
      'kullanici_secretToken': widget.fetchedMap['kullanici_secretToken']
    };
    bool dance = await User.resendMailCode(data);
    setState(() {
      loading = false;
      //TODO toast message
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          bottom: getPaddingScreenBottomHeight() + paddingHorizontal,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              height:
                  MediaQuery.of(context).size.height - 3 * paddingHorizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Logo(),
                  Box_View(
                    boxInside: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Emailinizi Onaylayın',
                          size: 16,
                        ),
                        AppText(
                          text:
                              'Size daha iyi hizmet verebilmemiz ve güvenliğinizi sağlayabilmemiz için lütfen e-posta adresinizi onaylayın. Onaylamak için mailinize gönderilen kodu girebilirsiniz.',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextfield(
                                  focusNode: _focusNode,
                                  controller: _editingController,
                                  keyboardType: TextInputType.number,
                                  align: TextAlign.center,
                                  size: 30,
                                  onChange: (String value) {
                                    if (value.length == 1) {
                                      setFocus(1);
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextfield(
                                  focusNode: _focusNode1,
                                  controller: _editingController1,
                                  keyboardType: TextInputType.number,
                                  align: TextAlign.center,
                                  onChange: (String value) {
                                    print(value.length);
                                    if (value.length == 1) {
                                      setFocus(2);
                                    }
                                    if (value.length == 0) {
                                      setFocus(0);
                                    }
                                  },
                                  size: 30,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextfield(
                                  focusNode: _focusNode2,
                                  controller: _editingController2,
                                  keyboardType: TextInputType.number,
                                  align: TextAlign.center,
                                  onChange: (String value) {
                                    if (value.length == 1) {
                                      setFocus(3);
                                    }
                                    if (value.length == 0) {
                                      setFocus(1);
                                    }
                                  },
                                  size: 30,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: CustomTextfield(
                                  focusNode: _focusNode3,
                                  controller: _editingController3,
                                  keyboardType: TextInputType.number,
                                  align: TextAlign.center,
                                  onChange: (String value) {
                                    if (value.length == 1) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    }
                                    if (value.length == 0) {
                                      setFocus(2);
                                    }
                                  },
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        error
                            ? Container(
                                child: AppText(
                                  text:
                                      'Girdiğiniz anahtar yanlıştır. lütfen tekrar deneyiniz',
                                  color: AppTheme.alertRed[0],
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  loading
                      ? Center(
                          child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: AppTheme.contrastColor1,
                          ),
                        ))
                      : Column(
                          children: [
                            GestureDetector(
                              onTap: resendMail,
                              child: Box_View(
                                boxInside: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: 'Maili Tekrar Gönder',
                                      size: 14,
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.envelope,
                                      color: AppTheme.textColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: isEmailOkay,
                              child: Box_View(
                                boxInside: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: 'Onayla',
                                      size: 14,
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.check,
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
            ),
          ),
        ));
  }
}
