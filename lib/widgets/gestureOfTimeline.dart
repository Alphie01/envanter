import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GestureTimeline extends StatefulWidget {
  const GestureTimeline({
    super.key,
  });

  @override
  State<GestureTimeline> createState() => _GestureTimelineState();
}

class _GestureTimelineState extends State<GestureTimeline> {
  String timePeriod = 'Bu Hafta';

  void setTimePeriod(String settimePeriod) {
    setState(() {
      timePeriod = settimePeriod;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              padding: EdgeInsets.all(paddingHorizontal),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(paddingHorizontal))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setTimePeriod('Bu Gün');
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: AppText(
                          text: 'Bu Gün',
                          size: 16,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setTimePeriod('Bu Hafta');
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: AppText(
                          text: 'Bu Hafta',
                          size: 16,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setTimePeriod('Bu Ay');
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: AppText(
                          text: 'Bu Ay',
                          size: 16,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setTimePeriod('Bu 6 Ay');
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: AppText(
                          text: 'Bu 6 Ay',
                          size: 16,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setTimePeriod('Bu Yıl');
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: paddingHorizontal),
                        child: AppText(
                          text: 'Bu Yıl',
                          size: 16,
                        )),
                  )
                ],
              ),
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: AppLargeText(
              text: '${timePeriod}',
              color: AppTheme.contrastColor4,
            ),
          ),
          FaIcon(
            FontAwesomeIcons.arrowDown,
            size: 14,
            color: AppTheme.contrastColor4,
          )
        ],
      ),
    );
  }
}
