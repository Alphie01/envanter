import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/profile/edit_profie/components/editable_container.dart';
import 'package:envanterimservetim/screens/profile/edit_profie/components/images_pickers.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  User? selectedUser;
  AnimationController? headerAnimationController;
  Animation<double>? headerAnimation;
  double offset = 0;
  bool isAnyChange = false, error = false;
  Color iconColor = Colors.white;
  int? userGender;
  String? userName,
      userKAdi,
      userBirthdate,
      userTC,
      userGsm,
      userAdres,
      userIl,
      userIlce;
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

    setState(() {
      userName = nullChecker(selectedUser!.userName);
      userKAdi = nullChecker(selectedUser!.userKAdi);
      userGender = selectedUser!.userGender;
      userBirthdate = nullChecker(selectedUser!.userBirthdate);
      userTC = nullChecker(selectedUser!.userTC);
      userGsm = nullChecker(selectedUser!.userGsm);
      userAdres = nullChecker(selectedUser!.userAdres);
      userIl = nullChecker(selectedUser!.userIl);
      userIlce = nullChecker(selectedUser!.userIlce);
    });
    super.initState();
    widget.animationController!.forward();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  String nullChecker(String? str) {
    return str == null ? '' : str;
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController _date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        isAnyChange = true;
        selectedDate = picked;
        userBirthdate = spliterDate(picked.toString());
      });
  }

  String spliterDate(String date) => date.split(' ')[0];
  String userGenderName(int gender) {
    if (gender == 1) {
      return 'Erkek';
    } else if (gender == 2) {
      return 'Kadın';
    }
    return 'Belirtilmedi';
  }

  Future updatePersonalDate() async {
    Map<String, dynamic> data = {
      'user_update': 'ok',
      'kullanici_mail': selectedUser!.userMail,
      'kullanici_secretToken': selectedUser!.token,
      'kullanici_adsoyad': userName,
      'kullanici_ad': userKAdi,
      'kullanici_birthDate': userBirthdate,
      'kullanici_tc': userTC,
      'kullanici_gsm': userGsm,
      'kullanici_adres': userAdres,
      'kullanici_il': userIl,
      'kullanici_ilce': userIlce,
      'kullanici_gender': userGender
    };
    bool dance = await User.updateUser(data);

    if (dance) {
      setState(() {
        selectedUser!.userName = userName!;
        selectedUser!.userKAdi = userKAdi!;
        selectedUser!.userBirthdate = userBirthdate;
        selectedUser!.userTC = userTC;
        selectedUser!.userGsm = userGsm;
        selectedUser!.userAdres = userAdres;
        selectedUser!.userIl = userIl;
        selectedUser!.userIlce = userIlce;
        selectedUser!.userGender = userGender!;
      });
      widget.updatePage!(pageId: 31);
    } else {
      setState(() {
        error = true;
        scrollController.animateTo(0.0,
            duration: defaultDuration, curve: Curves.easeInOut);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                      child: ListView(
                        padding: EdgeInsets.only(
                          top: getPaddingScreenTopHeight() +
                              AppBar().preferredSize.height,
                        ),
                        controller: scrollController,
                        shrinkWrap: true,
                        children: [
                          Box_View(
                            boxInside: Column(
                              children: [
                                Row(
                                  children: [AppLargeText(text: 'Fotoğraflar')],
                                ),
                                ImagesPickers(
                                  selectedUser: selectedUser!,
                                )
                              ],
                            ),
                          ),
                          Box_View(
                            boxInside: Column(
                              children: [
                                Row(
                                  children: [
                                    AppLargeText(text: 'Kişisel Bilgiler')
                                  ],
                                ),
                                EditableContainer(
                                  setFunction: (String str) {},
                                  containerValue:
                                      '${nullChecker(selectedUser!.userMail)}',
                                  containerName: 'Mail Adresiniz',
                                  disabled: true,
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userName = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userName)}',
                                  containerName: 'İsminiz',
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userTC = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userTC)}',
                                  containerName: 'TC Kimlik Numaranız',
                                  keyboardType: TextInputType.number,
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userKAdi = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userKAdi)}',
                                  containerName: 'Kullanıcı Adınız',
                                ),
                                GestureDetector(
                                  onTap: () => showModalBottomSheet(
                                      context: context,
                                      builder: (builder) {
                                        return GenderSelection(
                                          gender: userGender!,
                                          setGender: (int gender) {
                                            setState(() {
                                              userGender = gender;
                                              isAnyChange = true;
                                              Navigator.pop(context);
                                            });
                                          },
                                        );
                                      }),
                                  child: Box_View(
                                    horizontal: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Cinsiyet',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        AppText(
                                          text:
                                              '${userGenderName(userGender!)}',
                                          fontWeight: FontWeight.bold,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Box_View(
                                    horizontal: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Doğum Tarihiniz',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        AppText(
                                            text: userBirthdate != ''
                                                ? '$userBirthdate'
                                                : 'Belirtilmedi')
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Box_View(
                            boxInside: Column(
                              children: [
                                Row(
                                  children: [
                                    AppLargeText(text: 'İletişim Bilgiler')
                                  ],
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userGsm = '+90' + str;
                                    });
                                  },
                                  prefix: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: paddingHorizontal * .5,
                                        horizontal: paddingHorizontal),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.background1,
                                      borderRadius: BorderRadius.circular(
                                          paddingHorizontal),
                                    ),
                                    child: AppText(text: '+90'),
                                  ),
                                  containerValue:
                                      '${nullChecker(selectedUser!.userGsm)}',
                                  containerName: 'Telefon Numaranız',
                                  keyboardType: TextInputType.phone,
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userAdres = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userAdres)}',
                                  containerName: 'Adresiniz',
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userIlce = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userIlce)}',
                                  containerName: 'Bulunduğunuz İlçe',
                                ),
                                EditableContainer(
                                  setFunction: (String str) {
                                    setState(() {
                                      isAnyChange = true;
                                      userIl = str;
                                    });
                                  },
                                  containerValue:
                                      '${nullChecker(selectedUser!.userIl)}',
                                  containerName: 'Bulunduğunuz İl',
                                ),
                              ],
                            ),
                          ),
                          isAnyChange
                              ? GestureDetector(
                                  onTap: updatePersonalDate,
                                  child: Box_View(
                                    color:
                                        AppTheme.contrastColor1.withOpacity(.6),
                                    boxInside: Container(
                                      child: AppLargeText(text: 'Kaydet'),
                                    ),
                                  ),
                                )
                              : Container()
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
                    isCustom: isAnyChange,
                    customWidget: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(right: paddingHorizontal * .5),
                          child: AppLargeText(text: 'Kaydet'),
                        ),
                        FaIcon(
                          FontAwesomeIcons.cog,
                          color: AppTheme.textColor,
                          size: 20,
                        )
                      ],
                    ),
                    customWidgetUpdate: updatePersonalDate,
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

class GenderSelection extends StatelessWidget {
  const GenderSelection({
    super.key,
    this.gender = 0,
    required this.setGender,
  });
  final int gender;
  final Function(int) setGender;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      padding: EdgeInsets.fromLTRB(
          paddingHorizontal,
          paddingHorizontal,
          paddingHorizontal,
          paddingHorizontal + getPaddingScreenBottomHeight()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLargeText(text: 'Cinsiyetinizi Seçiniz'),
          AppText(
            text:
                'Cinsiyetinizi sadece başvurduğunuz ve içinde bulunduğunuz işletmeler tarafından görüntülenebilir.',
          ),
          GestureDetector(
            onTap: () => setGender(1),
            child: Box_View(
              horizontal: 0,
              boxInside: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(text: 'Erkek'),
                  gender == 1
                      ? FaIcon(
                          FontAwesomeIcons.check,
                          color: AppTheme.textColor,
                          size: 16,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setGender(2),
            child: Box_View(
              horizontal: 0,
              boxInside: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(text: 'Kadın'),
                  gender == 2
                      ? FaIcon(
                          FontAwesomeIcons.check,
                          color: AppTheme.textColor,
                          size: 16,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setGender(0),
            child: Box_View(
              horizontal: 0,
              boxInside: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLargeText(text: 'Belirtmek İstemiyorum'),
                  gender == 0
                      ? FaIcon(
                          FontAwesomeIcons.check,
                          color: AppTheme.textColor,
                          size: 16,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
