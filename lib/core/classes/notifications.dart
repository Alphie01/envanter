import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notifications {
  final String notificationString;
  final NotificationType notificationType;

  Notifications({
    required this.notificationString,
    required this.notificationType,
  });

  static List<Notifications> notify = [];

  static void notificationClear() => notify = [];

  static void initilazeNotifications(List<dynamic> notifications) {
    for (var element in notifications) {
      notify.add(
        Notifications(
          notificationString: element['notificationString'],
          notificationType: _notificationType(element['notificationType']),
        ),
      );
    }
  }

  static NotificationType _notificationType(int type) {
    switch (type) {
      case 0:
        return NotificationType.newProduct;
      case 1:
        return NotificationType.productSell;
      case 2:
        return NotificationType.newUserForCompany;
      case 3:
        return NotificationType.exitCompany;
      case 4:
        return NotificationType.lowStock;
      case 5:
        return NotificationType.noneStock;

      default:
        return NotificationType.lowStock;
    }
  }

  static Widget notificationWidget(Notifications notifications) {
    switch (notifications.notificationType) {
      case NotificationType.newProduct:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.plus,
                color: AppTheme.allowedGreen,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      case NotificationType.productSell:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.minus,
                color: AppTheme.alertRed[0],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      case NotificationType.newUserForCompany:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.user,
                color: AppTheme.allowedGreen,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );

      case NotificationType.exitCompany:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.user,
                color: AppTheme.alertRed[0],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      case NotificationType.lowStock:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.box,
                color: AppTheme.alertRed[0],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      case NotificationType.noneStock:
        return Box_View(
          boxInside: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.box,
                color: AppTheme.alertRed[0],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  child: AppText(
                    text: notifications.notificationString,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        );
      default:
        return Container();
    }
  }
}

enum NotificationType {
  newProduct,
  productSell,
  newUserForCompany,
  exitCompany,
  lowStock,
  noneStock
}
