import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCategories extends StatefulWidget {
  const ProductCategories({
    super.key,
    required this.selectOne,
  });

  final Function(Categories) selectOne;

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  Categories? categories;
  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLargeText(
            text: 'Ürün Kategorisi',
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (builder) {
                  return SelectCategories(
                    selectCategory: (Categories category) {
                      setState(() {
                        categories = category;
                      });
                      widget.selectOne(categories!);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
            child: Box_View(
              horizontal: 0,
              color: AppTheme.contrastColor1.withOpacity(.6),
              boxInside: categories != null
                  ? Row(
                      children: [
                        Expanded(
                          child: AppText(text: categories!.name),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child:
                              AppText(text: 'Ürünün Kategorisi Seçilmemiştir.'),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class SelectCategories extends StatefulWidget {
  const SelectCategories({
    super.key,
    required this.selectCategory,
  });

  @override
  State<SelectCategories> createState() => _SelectCategoriesState();
  final Function(Categories) selectCategory;
}

class _SelectCategoriesState extends State<SelectCategories> {
  Categories? selectedCategories;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .8,
      maxChildSize: .9,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.only(top: paddingHorizontal),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(paddingHorizontal),
            ),
          ),
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(
                controller: controller,
                padding: paddingZero,
                shrinkWrap: true,
                children: [
                  Box_View(
                    boxInside: AppLargeText(text: 'Ürünün Kategorisi'),
                  ),
                  Box_View(
                    boxInside: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: paddingHorizontal),
                          child: AppText(
                            text:
                                'Aşağıdaki birimlerden birisini seçerek ürününüzün birimini belirleyebilirsiniz, böylece siparişlerinizi daha etkili ve düzenli bir şekilde yönetebilirsiniz. Seçilen birim, ürün fiyatlandırması, stok takibi ve diğer işlemler için temel bir referans noktası olacaktır. Doğru bir birim seçimi, iş süreçlerinizi optimize etmenize ve müşterilerinize daha iyi hizmet sunmanıza yardımcı olacaktır.',
                            maxLineCount: 10,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: paddingZero,
                          itemCount: Categories.returnMainCategoriess().length,
                          itemBuilder: (ctx, index) {
                            return CategoriesSelection(
                              categories:
                                  Categories.returnMainCategoriess()[index],
                              selectedCategory: selectedCategories,
                              selectCategories: (Categories categories) {
                                setState(() {
                                  selectedCategories = categories;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              selectedCategories != null
                  ? GestureDetector(
                      onTap: () {
                        widget.selectCategory(selectedCategories!);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: getPaddingScreenBottomHeight()),
                        child: Box_View(
                          color: AppTheme.contrastColor1,
                          boxInside: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                text: 'Kategoriyi Seç',
                                fontWeight: FontWeight.bold,
                              ),
                              AppText(
                                text: '${selectedCategories!.name}',
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        );
      },
    );
  }
}

class CategoriesSelection extends StatelessWidget {
  const CategoriesSelection({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.selectCategories,
  });
  final Categories categories;
  final Categories? selectedCategory;
  final Function(Categories categories) selectCategories;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: paddingHorizontal / 2),
      padding: EdgeInsets.all(paddingHorizontal),
      decoration: BoxDecoration(
          color: AppTheme.background, borderRadius: defaultRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: Categories.isThereSubMenu(categories.menuTypeId)
                ? EdgeInsets.only(bottom: paddingHorizontal)
                : paddingZero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLargeText(
                  text: categories.name,
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    selectCategories(categories);
                  },
                  child: categories == selectedCategory
                      ? Container(
                          padding: EdgeInsets.all(paddingHorizontal / 2),
                          decoration: BoxDecoration(
                              color: AppTheme.contrastColor1,
                              borderRadius: defaultRadius),
                          child: AppText(text: 'Seçili'),
                        )
                      : Container(
                          padding: EdgeInsets.all(paddingHorizontal / 2),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.contrastColor1,
                              ),
                              borderRadius: defaultRadius),
                          child: AppText(text: 'Ana Kategoriyi Seç'),
                        ),
                )
              ],
            ),
          ),
          Categories.isThereSubMenu(categories.menuTypeId)
              ? Column(
                  children: [
                    ListView.builder(
                      itemCount:
                          Categories.returnSubCategoriess(categories.menuTypeId)
                              .length,
                      shrinkWrap: true,
                      padding: paddingZero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, ind) {
                        return GestureDetector(
                          onTap: () {
                            selectCategories(Categories.returnSubCategoriess(
                                categories.menuTypeId)[ind]);
                          },
                          child: ContainerOfCategories(
                            categories: Categories.returnSubCategoriess(
                                categories.menuTypeId)[ind],
                            isSelected: Categories.returnSubCategoriess(
                                    categories.menuTypeId)[ind] ==
                                selectedCategory,
                          ),
                        );
                      },
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

class ContainerOfCategories extends StatelessWidget {
  const ContainerOfCategories({
    super.key,
    required this.categories,
    required this.isSelected,
  });

  final Categories categories;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        bottom: paddingHorizontal / 2,
      ),
      padding: EdgeInsets.all(paddingHorizontal),
      decoration: BoxDecoration(
          color: AppTheme.contrastColor3, borderRadius: defaultRadius),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: categories.name,
            color: Colors.black,
          ),
          isSelected
              ? FaIcon(
                  FontAwesomeIcons.check,
                  size: 16,
                )
              : Container()
        ],
      ),
    );
  }
}
