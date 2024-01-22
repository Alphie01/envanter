import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/screens/homepage/component/introduce.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class NewTeammate extends StatefulWidget {
  const NewTeammate(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _NewTeammateState createState() => _NewTeammateState();
}

class _NewTeammateState extends State<NewTeammate>
    with TickerProviderStateMixin {
  bool isRefreshing = false, answeringPerson = true, isQRcode = true;
  String accessKey = '';

  final ScrollController scrollController = ScrollController();
  Animation<double>? topBarAnimation;
  double topBarOpacity = 0.0, searchBarOpacity = .6;

  //⁡⁣⁣⁢top Header Animations⁡
  AnimationController? filterAnimation, headerAnimationController;
  Animation<double>? filterOpacity, filterTransform, headerAnimation;
  Color iconColor = AppBlackTheme.textColor;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    headerAnimationController =
        AnimationController(vsync: this, duration: defaultDuration);

    headerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(headerAnimationController!);
    getAccessCode();
    super.initState();
    widget.animationController!.forward();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Future getAccessCode() async {
    setState(() {
      isRefreshing = true;
    });
    String code = await Shop.getAccessCode();
    setState(() {
      isRefreshing = false;
      accessKey = code;
    });
  }

  Future answerUser(User userInfo, bool answer) async {
    setState(() {
      answeringPerson = !answeringPerson;
    });
    bool isOkay =
        await Shop.shop_answerWaitingPeron(worker: userInfo, answer: answer);

    setState(() {
      answeringPerson = !answeringPerson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
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
                                AppBar().preferredSize.height),
                        child: ListView(
                          controller: scrollController,
                          padding: paddingZero,
                          shrinkWrap: true,
                          children: [
                            Box_View(
                              boxInside: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppLargeText(
                                      text: 'Yeni Takım Arkadaşı Ekle',
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'Yeni bir takım arkadaşı eklemek için lütfen aşağıdaki QR kodunu okutun. Bu özel güvenlik önlemi, işletmemizin veri güvenliği ve çalışanlarımızın güvenliği için tasarlanmıştır. QR kodunu paylaşırken dikkatli olun ve sadece yetkilendirilmiş kişilerle paylaşın. Güvenliği sağlamak için lütfen uygulamanızın güncel olduğundan emin olun.',
                                      maxLineCount: 99,
                                    ),
                                  ),
                                  Shop.selectedShop!.userPermissionLevel != 0
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isQRcode = true;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          paddingHorizontal),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: isQRcode
                                                            ? AppTheme
                                                                .contrastColor1
                                                                .withOpacity(1)
                                                            : AppTheme.textColor
                                                                .withOpacity(
                                                                    .4),
                                                      ),
                                                    ),
                                                  ),
                                                  child: AppLargeText(
                                                    text: 'QR kod ile davet et',
                                                    align: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    isQRcode = false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          paddingHorizontal),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: !isQRcode
                                                            ? AppTheme
                                                                .contrastColor1
                                                                .withOpacity(1)
                                                            : AppTheme.textColor
                                                                .withOpacity(
                                                                    .4),
                                                      ),
                                                    ),
                                                  ),
                                                  child: AppLargeText(
                                                    text: 'Davetiye Gönder',
                                                    align: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  isQRcode
                                      ? Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      paddingHorizontal * 3),
                                              child: SfBarcodeGenerator(
                                                barColor: AppTheme.textColor,
                                                value: accessKey,
                                                symbology: QRCode(),
                                              ),
                                            ),
                                            Center(
                                              child: AppLargeText(
                                                text:
                                                    'Ekleme Kodu : $accessKey',
                                              ),
                                            ),
                                          ],
                                        )
                                      : SendMAilToNewPerson()
                                ],
                              ),
                            ),
                            answeringPerson
                                ? Column(
                                    children: [
                                      Shop.selectedShop!.waitingApprove
                                                  .length !=
                                              0
                                          ? Box_View(
                                              boxInside: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              right:
                                                                  paddingHorizontal),
                                                          child: AppLargeText(
                                                            text:
                                                                'İşletmene Katılmak İsteyen Kişiler Var!',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ListView.builder(
                                                    itemCount: Shop
                                                        .selectedShop!
                                                        .waitingApprove
                                                        .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return WaitingApprovePerson(
                                                        userInfo: Shop
                                                                .selectedShop!
                                                                .waitingApprove[
                                                            index],
                                                        declinePerson:
                                                            (User userInfo) {
                                                          answerUser(
                                                              userInfo, false);
                                                        },
                                                        approvePerson:
                                                            (User userInfo) {
                                                          answerUser(
                                                              userInfo, true);
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Box_View(
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  bottom: paddingHorizontal),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right:
                                                              paddingHorizontal),
                                                      child: AppLargeText(
                                                        text:
                                                            'Çalışma Arkadaşlarım',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Shop.selectedShop!.shopWorkers
                                                        .length ==
                                                    0
                                                ? Container(
                                                    height: 250,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppTheme.background,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              paddingHorizontal),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: AppLargeText(
                                                      text:
                                                          'İşletmenizde Sizden Başka Birisi Çalışmamaktadır.',
                                                      align: TextAlign.center,
                                                    ),
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: paddingZero,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: Shop
                                                        .selectedShop!
                                                        .shopWorkers
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (Shop.selectedShop!
                                                                  .userPermissionLevel !=
                                                              0) {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (builder) {
                                                                return ModalOfTeammateSettings(
                                                                  selectedUserInfo: Shop
                                                                      .selectedShop!
                                                                      .shopWorkers[index],
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Teammate_User(
                                                          teammate: Shop
                                                                  .selectedShop!
                                                                  .shopWorkers[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(),
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
              AnimatedBuilder(
                animation: headerAnimation!,
                builder: (BuildContext context, Widget? child) {
                  return HeaderWidget(
                    blurOpacity: headerAnimation!.value,
                    headerColor:
                        AppTheme.background.withOpacity(headerAnimation!.value),
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

class SendMAilToNewPerson extends StatefulWidget {
  const SendMAilToNewPerson({
    super.key,
  });

  @override
  State<SendMAilToNewPerson> createState() => _SendMAilToNewPersonState();
}

class _SendMAilToNewPersonState extends State<SendMAilToNewPerson> {
  String emailThatSearch = '',
      wrongEmailString = "Aradığınız Email'e Sahip Bir Kişi Bulunamamıştır.",
      initEmail =
          'Aramak İstediğiniz Emaili Arama Kısmına Yazarak Aramaya Başla!';
  bool isSearched = false, isFetching = false, isError = false;
  List<User> askedUsers = [];

  Future getUsers() async {
    if (emailThatSearch.length > 4) {
      setState(() {
        askedUsers = [];
        isFetching = true;
        isSearched = false;
      });
      List<User>? fetchedUsers = await Shop.getUserByMails(emailThatSearch);
      setState(() {
        askedUsers = fetchedUsers ?? [];
        isFetching = false;
        if (askedUsers.isEmpty) {
          isSearched = true;
        } else {}
      });
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  void _showAlertDialogAddNewPerson(BuildContext context, User selectedUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          title: AppLargeText(text: 'Uyarı! '),
          content: App_Rich_Text(
            text: [
              'İşletmenize ',
              '${selectedUser.userName}',
              ' isimli kişiyi katmak istediğinize emin misiniz'
            ],
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AppText(
                text: 'Kayıt Et',
                color: AppTheme.alertGreen[0],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: paddingHorizontal,
        ),
        Box_View(
          horizontal: 0,
          color: AppTheme.background,
          boxInside: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      hintText: 'Eklemek İstediğiniz Kişinin E-mail Adresi',
                      isLast: true,
                      onChange: (String string) {
                        setState(() {
                          emailThatSearch = string;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: getUsers,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: paddingHorizontal),
                      decoration: BoxDecoration(
                          color: AppTheme.contrastColor1,
                          shape: BoxShape.circle),
                      child: FaIcon(
                        FontAwesomeIcons.search,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                ],
              ),
              isError
                  ? Container(
                      padding: EdgeInsets.only(top: paddingHorizontal),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.warning,
                            color: AppTheme.alertRed[0],
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: paddingHorizontal),
                            child: AppText(
                              text:
                                  'Email adresini doğru girdiğinizden emin olun!',
                              color: AppTheme.alertRed[0],
                            ),
                          ))
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        Box_View(
          horizontal: 0,
          color: AppTheme.background,
          boxInside: Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * .3,
            child: isFetching
                ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: AppTheme.textColor,
                      ),
                    ),
                  )
                : askedUsers.isEmpty
                    ? AppLargeText(
                        text: isSearched ? wrongEmailString : initEmail,
                        align: TextAlign.center,
                      )
                    : ListView.builder(
                        itemCount: askedUsers.length,
                        padding: paddingZero,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              _showAlertDialogAddNewPerson(
                                  context, askedUsers[index]);
                            },
                            child: Container(
                              padding: EdgeInsets.all(paddingHorizontal),
                              margin:
                                  EdgeInsets.only(bottom: paddingHorizontal),
                              decoration: BoxDecoration(
                                color: AppTheme.background1,
                                borderRadius: defaultRadius,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: NetworkContainer(
                                      borderRadius: BorderRadius.circular(50),
                                      imageUrl:
                                          askedUsers[index].userProfilePhoto,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: paddingHorizontal),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppLargeText(
                                              text:
                                                  '${askedUsers[index].userName}'),
                                          AppText(
                                              text:
                                                  '${askedUsers[index].userMail}'),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                          ;
                        },
                      ),
          ),
        ),
      ],
    );
  }
}

class ModalOfTeammateSettings extends StatefulWidget {
  const ModalOfTeammateSettings({
    super.key,
    required this.selectedUserInfo,
  });
  final User selectedUserInfo;

  @override
  State<ModalOfTeammateSettings> createState() =>
      _ModalOfTeammateSettingsState();
}

class _ModalOfTeammateSettingsState extends State<ModalOfTeammateSettings> {
  User? selectedPerson;
  bool isFetchedMore = false;

  @override
  void initState() {
    setState(() {
      selectedPerson = widget.selectedUserInfo;
    });
    fetchMoreInfo();
    super.initState();
  }

  Future fetchMoreInfo() async {
    User fetchedUser = await Shop.getWorkerMoreInfo(widget.selectedUserInfo);
    setState(() {
      selectedPerson = fetchedUser;
      isFetchedMore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: paddingHorizontal),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(paddingHorizontal),
        ),
        color: AppTheme.background,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Box_View(
            boxInside: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: NetworkContainer(
                      imageUrl: selectedPerson!.userProfilePhoto),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: paddingHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AppLargeText(text: selectedPerson!.userName),
                        AppText(text: selectedPerson!.userMail),
                        AppText(
                            text:
                                '${Shop.permissionLevel(int.parse(selectedPerson!.userPermissionLevel!))}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isFetchedMore
              ? Box_View(
                  boxInside: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          App_Rich_Text(
                            text: [
                              '',
                              'Telefon Numarası:',
                              ' ${selectedPerson!.userGsm}'
                            ],
                          ),
                          App_Rich_Text(
                            text: [
                              '',
                              'Adres:',
                              ' ${selectedPerson!.userAdres}'
                            ],
                          ),
                          App_Rich_Text(
                            text: ['', 'İl:', ' ${selectedPerson!.userIl}'],
                          ),
                          App_Rich_Text(
                            text: ['', 'İlçe:', ' ${selectedPerson!.userIlce}'],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Container(
                    margin: EdgeInsets.only(top: paddingHorizontal),
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      color: AppTheme.textColor,
                    ),
                  ),
                ),
          Expanded(
            child: Box_View(
              boxInside: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: double.maxFinite,
                      child: AppLargeText(text: 'Yapılabilecek İşlemler')),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: paddingZero,
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.background,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(paddingHorizontal),
                                    ),
                                  ),
                                  padding:
                                      EdgeInsets.only(top: paddingHorizontal),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Box_View(
                                        boxInside: Row(
                                          children: [
                                            AppLargeText(
                                                text:
                                                    'Kullanıcının Yetkisini Belirle'),
                                          ],
                                        ),
                                      ),
                                      Box_View(
                                        color: selectedPerson!
                                                    .userPermissionLevel! ==
                                                '0'
                                            ? AppTheme.contrastColor1
                                                .withOpacity(.6)
                                            : null,
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppLargeText(text: 'Kullanıcı'),
                                            Container(
                                              width: double.maxFinite,
                                              child: AppText(text: 'text'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Box_View(
                                        color: selectedPerson!
                                                    .userPermissionLevel! ==
                                                '1'
                                            ? AppTheme.contrastColor1
                                                .withOpacity(.6)
                                            : null,
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppLargeText(
                                                text: 'Yetkili Kullanıcı'),
                                            Container(
                                              width: double.maxFinite,
                                              child: AppText(text: 'text'),
                                            )
                                          ],
                                        ),
                                      ),
                                      Box_View(
                                        color: selectedPerson!
                                                    .userPermissionLevel! ==
                                                '5'
                                            ? AppTheme.contrastColor1
                                                .withOpacity(.6)
                                            : null,
                                        boxInside: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppLargeText(
                                                text: 'İşletme Sahibi'),
                                            Container(
                                              width: double.maxFinite,
                                              child: AppText(text: 'text'),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: CanDoButtons(
                            icon: FontAwesomeIcons.person,
                            string: 'Yetkisini \nDüzenle',
                          ),
                        ),
                        CanDoButtons(
                          boxColor: AppTheme.allowedGreen.withOpacity(.4),
                          icon: FontAwesomeIcons.phone,
                          string: 'Şimdi \nAra',
                        ),
                        CanDoButtons(
                          boxColor: AppTheme.allowedGreen.withOpacity(.4),
                          icon: FontAwesomeIcons.envelope,
                          string: 'Şimdi \nMail Yolla',
                        ),
                        CanDoButtons(
                          boxColor: AppTheme.alertRed[0].withOpacity(.4),
                          icon: FontAwesomeIcons.x,
                          string: 'İşletmeden \nUzaklaştır',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CanDoButtons extends StatelessWidget {
  const CanDoButtons({
    super.key,
    this.onTap,
    required this.string,
    this.icon,
    this.boxColor,
  });
  final Function? onTap;
  final String string;
  final Color? boxColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .4,
      margin: EdgeInsets.only(right: paddingHorizontal),
      child: Box_View(
        color: boxColor ?? AppTheme.background,
        horizontal: 0,
        boxInside: Stack(
          alignment: Alignment.topRight,
          children: [
            icon != null
                ? FaIcon(
                    icon,
                    size: 56,
                    color: AppTheme.textColor.withOpacity(.4),
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: string),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingApprovePerson extends StatelessWidget {
  const WaitingApprovePerson({
    super.key,
    required this.declinePerson,
    required this.approvePerson,
    required this.userInfo,
  });
  final Function(User) declinePerson, approvePerson;
  final User userInfo;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.background, borderRadius: defaultRadius),
      padding: EdgeInsets.all(paddingHorizontal),
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: NetworkContainer(
              borderRadius: BorderRadius.circular(50),
              imageUrl: userInfo.userProfilePhoto,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: '${userInfo.userName}'),
                  AppText(text: '${userInfo.userMail}'),
                ],
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  declinePerson(userInfo);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(right: paddingHorizontal),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppTheme.alertRed[0]),
                  child: const FaIcon(
                    FontAwesomeIcons.x,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  approvePerson(userInfo);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppTheme.alertGreen[0]),
                  child: const FaIcon(
                    FontAwesomeIcons.check,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Teammate_User extends StatelessWidget {
  const Teammate_User({
    super.key,
    required this.teammate,
  });
  final User teammate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(paddingHorizontal),
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: defaultRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            child: NetworkContainer(
              borderRadius: BorderRadius.circular(50),
              imageUrl: teammate.userProfilePhoto,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: paddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLargeText(text: '${teammate.userName}'),
                  AppText(text: '${teammate.userMail}'),
                  AppText(
                      text:
                          '${Shop.permissionLevel(int.parse(teammate.userPermissionLevel!))}'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
