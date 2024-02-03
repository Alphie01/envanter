import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile(
      {Key? key,
      this.animationController,
      this.updatePage,
      required this.scaffoldKey})
      : super(key: key);

  final AnimationController? animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function? updatePage;

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    super.initState();
    widget.animationController!.forward();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onPanUpdate: (details) {},
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
                      child: Container(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
