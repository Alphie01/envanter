
import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ParentCatagories extends StatelessWidget {
  const ParentCatagories({
    super.key,
    required this.selectedCatagories,
  });
  final Function(String, int, int) selectedCatagories;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(paddingHorizontal),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        paddingHorizontal,
        paddingHorizontal,
        paddingHorizontal,
        paddingHorizontal + getPaddingScreenBottomHeight(),
      ),
      child: ListView(
        padding: paddingZero,
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              selectedCatagories(
                  'Hayır, Herhangi Üst Menu Bulunmamaktadır!', -1, -1);
            },
            child: Container(
              padding: EdgeInsets.all(paddingHorizontal),
              child: AppText(text: 'Hayır, Herhangi Üst Menu Bulunmamaktadır!'),
            ),
          ),
          ListView.builder(
            padding: paddingZero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: Categories.returnMainCategoriess().length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  selectedCatagories(
                      Categories.returnMainCategoriess()[index].name,
                      Categories.returnMainCategoriess()[index].menuTypeId,
                      Categories.returnMainCategoriess()[index].subCategoriesId);
                },
                child: Container(
                  padding: EdgeInsets.all(paddingHorizontal),
                  child:
                      AppText(text: Categories.returnMainCategoriess()[index].name),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
