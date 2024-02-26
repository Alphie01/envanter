import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Currencies extends StatelessWidget {
  const Currencies({super.key});

  String actualDouble(double s) => (1 / s).toStringAsFixed(2);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: paddingHorizontal),
      height: 35,
      child: ListView.builder(
        padding: paddingZero,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: ParaBirimi.paraBirimleri.length,
        itemBuilder: (ctx, index) {
          ParaBirimi object = ParaBirimi.paraBirimleri[index];
          return Container(
            margin: EdgeInsets.only(right: paddingHorizontal * .5),
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppTheme.contrastColor1.withOpacity(.6),
                borderRadius: BorderRadius.circular(paddingHorizontal)),
            child: Row(
              children: [
                AppText(
                  text: '${object.kod}',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: paddingHorizontal),
                  child: AppText(
                    text: '${actualDouble(object.buy!)}₺',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
