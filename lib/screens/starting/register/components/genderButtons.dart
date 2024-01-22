import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class GenderButtons extends StatelessWidget {
  final Function widgetFunction;
  bool selected;
  final String insideText;
  GenderButtons(
      {super.key,
      required this.insideText,
      required this.widgetFunction,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widgetFunction();
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.background),
            color: selected ? AppTheme.background : Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: insideText,
              color: selected ? AppTheme.textColor : AppTheme.background,
            ),
            selected ? FaIcon(FontAwesomeIcons.check) : Container()
          ],
        ),
      ),
    );
  }
}
