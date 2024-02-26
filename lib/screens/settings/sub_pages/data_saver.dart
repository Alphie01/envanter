import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/core/sharedPref/sharedpreferences.dart';
import 'package:envanterimservetim/core/sharedPref/sharedprefkeynames.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/headerWidget.dart';
import 'package:flutter/material.dart';

class DataSaver extends StatefulWidget {
  const DataSaver(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _DataSaverState createState() => _DataSaverState();
}

class _DataSaverState extends State<DataSaver> with TickerProviderStateMixin {
  bool isRefreshing = false, answeringPerson = true, isQRcode = true;
  String accessKey = '';

  final ScrollController scrollController = ScrollController();
  Animation<double>? topBarAnimation;
  double topBarOpacity = 0.0, searchBarOpacity = .6;

  //⁡⁣⁣⁢top Header Animations⁡
  AnimationController? filterAnimation, headerAnimationController;
  Animation<double>? filterOpacity, filterTransform, headerAnimation;
  Color iconColor = AppTheme.textColor;
  bool? switchPos;

  @override
  void initState() {
    setState(() {
      switchPos = AppTheme.dataSaverMode;
    });
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void switchDataSaver(bool val) {
    
    setState(() {
      SharedPref.addBoolToSF(dataSaverMode, val);
      switchPos = val;
      AppTheme.dataSaverMode = val;
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppLargeText(text: 'Data Saving Modu'),
                                      Switch(
                                        // thumb color (round icon)
                                        activeColor: AppTheme.contrastColor1,
                                        activeTrackColor: AppTheme
                                            .contrastColor1
                                            .withOpacity(.3),
                                        inactiveThumbColor:
                                            Colors.blueGrey.shade600,
                                        inactiveTrackColor:
                                            Colors.grey.shade400,
                                        splashRadius: 20.0,
                                        // boolean variable value
                                        value: switchPos!,
                                        // changes the state of the switch
                                        onChanged: (value) {
                                          switchDataSaver(value);
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: paddingHorizontal),
                                    child: AppText(
                                      text:
                                          'Data Saving Modu, kullanıcıların internet verilerini daha verimli kullanmalarını sağlayan özel bir moddur. Bu mod sayesinde, mobil veri kullanımınızı azaltabilir ve internet paketinizden daha uzun süre faydalanabilirsiniz. Veri tasarrufu yaparak, Uygulamanın daha hızlı yüklenmesini sağlayabilirsiniz.',
                                      maxLineCount: 99,
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
