import 'package:envanterimservetim/core/classes/product.dart';
import 'package:envanterimservetim/core/classes/shop.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';

class ShopProductEnterence extends StatelessWidget {
  const ShopProductEnterence({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            child: AppLargeText(
              text: 'Yeni Ürün Eklemek İstiyorum!',
              
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            child: App_Rich_Text(
              text: [
                "Şu anda ",
                "'${Shop.selectedShop!.shop_name}'",
                " içerisinde ",
                "${Product.products.length} ürün",
                " bulunmamaktadır. İşletmenize gelen müşterilere daha etkili bir şekilde ulaşmak ve onları daha rahat bir şekilde müdavim yapmak için ürün çeşitliliğinizi artırmanız önemlidir. ",
                "Farklı seçenekler sunarak müşterilerin beklentilerine cevap vermek, işletmenizi daha çekici ve rekabet avantajına sahip kılacaktır. ",
                "Yeni ürünler ekleyerek mevcut müşterilerinizi memnun etmenin yanı sıra, potansiyel müşterileri de çekebilir ve işletmenizin büyümesine katkıda bulunabilirsiniz. Ürün portföyünüzü genişletmek, ",
                "'${Shop.selectedShop!.shop_name}'ın ",
                "müşteri tabanını güçlendirmek için etkili bir strateji olabilir."
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: paddingHorizontal),
            child: AppText(
              text: 'Haydi Eklemeye Başlıyalım Mı?',
              fontWeight: FontWeight.bold,
            ),
          ),
          AppText(
            text: 'Not : Yıldız(*) bulunan bölümleri doldurmanız zorunludur!',
            fontWeight: FontWeight.bold,
          )
        ],
      ),
    );
  }
}

class ShopEnterenceSecond extends StatelessWidget {
  const ShopEnterenceSecond({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Box_View(
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLargeText(
            text: 'Çok Güzel İlerleme Kaydettik!',
          ),
          Container(
            padding: EdgeInsets.only(top: paddingHorizontal),
            child: AppText(
              text:
                  'Harika ilerleme kaydetmiş bulunmaktayız! Ürününüzün tamamlanması için sadece birkaç adım kalmış durumda. Bu süreçte gösterdiğiniz çaba ve katkılar, ürününüzün başarılı bir şekilde hayata geçirilmesine önemli ölçüde katkıda bulunuyor. Sizi bu süreçte desteklemek ve her adımda yanınızda olmak için buradayız.',
              maxLineCount: 10,
            ),
          )
        ],
      ),
    );
  }
}
