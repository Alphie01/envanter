import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastProcess extends StatelessWidget {
  const FastProcess(
      {super.key,
      required this.containerName,
      this.containerColor,
      required this.containerSubText,
      required this.containerIconData,
      required this.containerFunction});
  final String containerName, containerSubText;
  final Color? containerColor;
  final IconData containerIconData;
  final Function containerFunction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        containerFunction();
      },
      child: Container(
        padding: EdgeInsets.all(paddingHorizontal),
        decoration: BoxDecoration(
          color: containerColor ?? AppTheme.background,
          borderRadius: defaultRadius,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            FaIcon(
              containerIconData,
              color: AppTheme.contrastColor1.withOpacity(.3),
              size: 54,
            ),
            Container(
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  containerName != 'Kilitli'
                      ? AppText(
                          text: containerName,
                          size: 14,
                          fontWeight: FontWeight.bold,
                        )
                      : Container(
                          padding:
                              EdgeInsets.only(bottom: paddingHorizontal / 2),
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            color: AppTheme.textColor,
                          ),
                        ),
                  AppText(text: containerSubText)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
