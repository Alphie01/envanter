import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ConfimationPage extends StatefulWidget {
  const ConfimationPage({
    super.key,
    required this.nextPage,
    required this.confirmationNumber,
  });
  final Function nextPage;
  final int confirmationNumber;

  @override
  State<ConfimationPage> createState() => _ConfimationPageState();
}

class _ConfimationPageState extends State<ConfimationPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLargeText(
            text: 'Neredeyse Tamamladık!',
            color: AppTheme.background,
          ),
          AppText(
            text: 'text',
            color: AppTheme.background,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppTheme.background))),
                  child: TextField(
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppTheme.background))),
                  child: TextField(
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppTheme.background))),
                  child: TextField(
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppTheme.background))),
                  child: TextField(
                    keyboardType: TextInputType.number,
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.nextPage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 25),
              width: double.maxFinite,
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: AppLargeText(
                text: 'Devam Et',
                color: AppTheme.background,
                size: 16,
              ),
              decoration: BoxDecoration(color: AppTheme.firstColor),
            ),
          ),
        ],
      ),
    );
  }
}
