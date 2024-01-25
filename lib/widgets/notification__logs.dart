import 'package:envanterimservetim/core/classes/notifications.dart';
import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notification_Logs extends StatefulWidget {
  const Notification_Logs({
    super.key,
  });

  @override
  State<Notification_Logs> createState() => _Notification_LogsState();
}

class _Notification_LogsState extends State<Notification_Logs> {
  List<Notifications> _notifications = [];

  @override
  void initState() {
    setState(() {
      _notifications = Notifications.notify;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .45,
      maxChildSize: .9,
      builder: (_, controller) {
        return Container(
          color: AppTheme.background,
          width: double.maxFinite,
          child: ListView(
            controller: controller,
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.all(
                  paddingHorizontal,
                ),
                child: AppLargeText(text: 'İşletme Bildirimleri'),
              ),
              Container(
                padding: EdgeInsets.all(
                  paddingHorizontal,
                ),
                child: AppText(
                  text:
                      'Aşağıdaki birimlerden birisini seçerek ürününüzün birimini belirleyebilirsiniz, böylece siparişlerinizi daha etkili ve düzenli bir şekilde yönetebilirsiniz. Seçilen birim, ürün fiyatlandırması, stok takibi ve diğer işlemler için temel bir referans noktası olacaktır. Doğru bir birim seçimi, iş süreçlerinizi optimize etmenize ve müşterilerinize daha iyi hizmet sunmanıza yardımcı olacaktır',
                  maxLineCount: 10,
                ),
              ),
              _notifications.isEmpty
                  ? Box_View(
                      boxInside: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: paddingHorizontal),
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              color: AppTheme.textColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: paddingHorizontal),
                            child: AppLargeText(
                                text: 'Bildiriminiz Bulunmamaktadır.'),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notifications.length,
                      shrinkWrap: true,
                      padding: paddingZero,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Notifications.notificationWidget(
                            _notifications[index]);
                      },
                    )
            ],
          ),
        );
      },
    );
  }
}
