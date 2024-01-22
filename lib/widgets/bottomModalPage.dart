import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:flutter/material.dart';

class BottomModalSheetContainer extends StatefulWidget {
  const BottomModalSheetContainer({
    super.key,
    this.updatePage,
    this.children,
    this.physics,
  });
  final Function? updatePage;
  final List<Widget>? children;
  final ScrollPhysics? physics;

  @override
  State<BottomModalSheetContainer> createState() =>
      _BottomModalSheetContainerState();
}

class _BottomModalSheetContainerState extends State<BottomModalSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0),
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        builder: (_, controller) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: getPaddingScreenBottomHeight(),
              top: getPaddingScreenTopHeight(),
            ),
            child: ListView(
              physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: paddingZero,
              controller: controller,
              children: widget.children!,
            ),
          );
        },
      ),
    );
  }
}
