import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:flutter/material.dart';

class Box_View extends StatelessWidget {
  final Widget boxInside;
  final double? horizontal;
  final double? vertical;
  final Color? color;
  const Box_View({
    super.key,
    required this.boxInside,
    this.horizontal,
    this.color,
    this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? paddingHorizontal,
          vertical: vertical ?? paddingHorizontal / 2),
      child: Container(
          padding: EdgeInsets.all(paddingHorizontal),
          decoration: BoxDecoration(
              color: color ?? AppTheme.background1,
              borderRadius: defaultRadius),
          child: boxInside),
    );
  }
}
