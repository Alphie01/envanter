import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/networkImage.dart';
import 'package:flutter/material.dart';

class SimularProducts extends StatelessWidget {
  const SimularProducts({
    super.key,
    required this.simular,
  });
  final Product simular;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: defaultRadius),
      child: Stack(
        children: [
          NetworkContainer(
            imageUrl: simular.images!.length != 0
                ? simular.images!.first
                : NetworkImage(
                    'https://dev.elektronikey.com/products/products.png'),
          ),
          Container(
            padding: EdgeInsets.all(paddingHorizontal),
            decoration: BoxDecoration(
              borderRadius: defaultRadius,
              color: AppTheme.background.withOpacity(.6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    AppLargeText(text: simular.title!),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
