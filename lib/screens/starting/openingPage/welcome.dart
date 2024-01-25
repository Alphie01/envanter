import 'dart:ui';
import 'package:envanterimservetim/core/classes/user.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomeScreen extends StatefulWidget {
  final AnimationController? animationController;
  final Function? updatePage;
  const WelcomeScreen({Key? key, this.animationController, this.updatePage})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController? swipeAnimation;
  Animation? animation1, animation2, reload;

  List welcomePhotos = [
    [
      'assets/welcome/1.jpg',
      'assets/welcome/2.jpg',
      'assets/welcome/3.jpg',
      'assets/welcome/4.jpg',
    ],
    [
      'assets/welcome/5.jpg',
      'assets/welcome/6.jpg',
      'assets/welcome/7.jpg',
      'assets/welcome/8.jpg',
    ],
    [
      'assets/welcome/9.jpg',
      'assets/welcome/10.jpg',
      'assets/welcome/11.jpg',
      'assets/welcome/12.jpg',
    ],
  ];

  @override
  void initState() {
    User.logout();
    swipeAnimation = AnimationController(
        duration: Duration(seconds: 8), vsync: this)
      ..addListener(() {
        if (swipeAnimation!.isCompleted) {
          swipeAnimation!.reverse().then((value) => swipeAnimation!.repeat());
        }
      });

    animation1 = Tween<double>(begin: 0, end: -150).animate(swipeAnimation!);
    animation2 = Tween<double>(begin: -150, end: 0).animate(swipeAnimation!);
    reload = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: widget.animationController!, curve: Curves.fastOutSlowIn));

    swipeAnimation!.forward();
    widget.animationController!.forward();

    super.initState();
  }

  @override
  void dispose() {
    swipeAnimation!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: reload!,
      builder: ((context, child) {
        return Opacity(
          opacity: reload!.value,
          child: Scaffold(
            body: Stack(
              children: [
                BackgroundAnimation(context),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding:
                        EdgeInsets.only(bottom: getPaddingScreenBottomHeight()),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.7),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15))),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5.0,
                          sigmaY: 5.0,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                child: AppLargeText(
                                  text: 'logo',
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                child: AppText(
                                  text:
                                      'E-Ticaret Sistemlerini \ndaha Kolay Yönet!',
                                  color: Colors.white,
                                  align: TextAlign.center,
                                  size: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.updatePage!(pageId: 91);
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
                                        text: 'Devam Et',
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Container BackgroundAnimation(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
              child: ListView.builder(
                itemCount: 4,
                padding: paddingZero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: animation1!,
                    builder: ((context, child) {
                      return Transform.translate(
                        offset: Offset(0, animation1!.value),
                        child: Container(
                          height: 250,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(welcomePhotos[0][index]),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
              child: ListView.builder(
                itemCount: 4,
                padding: paddingZero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: animation2!,
                    builder: ((context, child) {
                      return Transform.translate(
                        offset: Offset(0, animation2!.value),
                        child: Container(
                          height: 250,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(welcomePhotos[1][index]),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 15),
              child: ListView.builder(
                itemCount: 4,
                padding: paddingZero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: animation1!,
                    builder: ((context, child) {
                      return Transform.translate(
                        offset: Offset(0, animation1!.value),
                        child: Container(
                          height: 250,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(welcomePhotos[2][index]),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
