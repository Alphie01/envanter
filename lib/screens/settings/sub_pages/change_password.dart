import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with TickerProviderStateMixin {
  bool isRefreshing = false, answeringPerson = true, isQRcode = true;
  String accessKey = '';

  final ScrollController scrollController = ScrollController();
  Animation<double>? topBarAnimation;
  double topBarOpacity = 0.0, searchBarOpacity = .6;

  //⁡⁣⁣⁢top Header Animations⁡
  AnimationController? filterAnimation, headerAnimationController;
  Animation<double>? filterOpacity, filterTransform, headerAnimation;
  Color iconColor = AppTheme.textColor;

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

    super.initState();
    widget.animationController!.forward();
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
                                  Row(
                                    children: [
                                      AppLargeText(
                                        text: 'Şifremi Değiştirmek İstiyorum',
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: paddingHorizontal * .5),
                                    child: AppText(text: 'text'),
                                  ),
                                  Box_View(
                                    horizontal: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: paddingHorizontal),
                                          child: AppText(text: 'Eski Şifreniz'),
                                        ),
                                        Expanded(
                                          child: CustomTextfield(
                                            hintText: 'Eski Şifreniz',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Box_View(
                                    horizontal: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: paddingHorizontal),
                                          child: AppText(text: 'Yeni Şifreniz'),
                                        ),
                                        Expanded(
                                          child: CustomTextfield(
                                            hintText: 'Yeni Şifreniz',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Box_View(
                                    horizontal: 0,
                                    color: AppTheme.background,
                                    boxInside: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: paddingHorizontal),
                                          child: AppText(text: 'Yeni Şifreniz'),
                                        ),
                                        Expanded(
                                          child: CustomTextfield(
                                            hintText: 'Yeni Şifreniz',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Box_View(
                                    horizontal: 0,
                                    color:
                                        AppTheme.contrastColor1.withOpacity(.6),
                                    boxInside: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppLargeText(text: 'Şifremi Değiştir'),
                                        FaIcon(
                                          FontAwesomeIcons.lock,
                                          color: AppTheme.textColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
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
