import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Refresh_widget extends StatefulWidget {
  const Refresh_widget({
    super.key,
    required this.scrollOffset,
    this.refreshPage,
  });
  final double scrollOffset;
  final Function? refreshPage;
  @override
  State<Refresh_widget> createState() => _Refresh_widgetState();
}

class _Refresh_widgetState extends State<Refresh_widget> {
  bool maxed = false;

  @override
  void initState() {
    print(widget.scrollOffset);

    super.initState();
  }

  Future refreshShopDatas() async {
    bool dance = await Shop.shop_init();
    setState(() {
      maxed = false;
    });
    if (dance) {
      widget.refreshPage;
    }
  }

  double animationOpacity() {
    if (widget.scrollOffset < 0) {
      if (-widget.scrollOffset <= 100) {
        return -widget.scrollOffset / 100;
      } else {
        setState(() {
          maxed = true;
        });
        refreshShopDatas();
        return 1;
      }
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: maxed ? 1 : animationOpacity(),
      child: Container(
        margin: EdgeInsets.only(
          top: getPaddingScreenTopHeight() + AppBar().preferredSize.height,
        ),
        child: Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.all(paddingHorizontal),
          decoration: BoxDecoration(
            color: AppTheme.background,
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(
            color: AppTheme.contrastColor1,
          ),
        ),
      ),
    );
  }
}
