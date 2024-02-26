import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:envanterimservetim/widgets/app_text.dart';
import 'package:envanterimservetim/widgets/box_view.dart';
import 'package:envanterimservetim/widgets/textfield.dart';
import 'package:flutter/material.dart';

class EditableContainer extends StatelessWidget {
  const EditableContainer({
    super.key,
    required this.setFunction,
    required this.containerValue,
    required this.containerName,
    this.disabled = false,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.prefix,
  });
  final TextInputType keyboardType;
  final Function(String str) setFunction;
  final String containerValue, containerName;
  final bool disabled;
  final Widget? prefix;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Box_View(
      color: AppTheme.background,
      horizontal: 0,
      boxInside: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: containerName,
                fontWeight: FontWeight.bold,
              ),
              disabled
                  ? AppText(
                      text: '*Değiştirilemez',
                      fontWeight: FontWeight.bold,
                    )
                  : Container(),
            ],
          ),
          CustomTextfield(
            /* focusNode: FocusNode(), */
            keyboardType: keyboardType,
            prefix: prefix,
            disabled: disabled,
            value: containerValue,
            hintText: containerName,
            onChange: setFunction,
          )
        ],
      ),
    );
  }
}
