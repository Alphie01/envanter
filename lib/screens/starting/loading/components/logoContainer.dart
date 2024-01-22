import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: paddingHorizontal),
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: paddingHorizontal),
          child: AppText(
            text: 'Envanterim İş Hayatım',
            size: 20,
            color: AppBlackTheme.textColor,
          ),
        ),
      ],
    );
  }
}
