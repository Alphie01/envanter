import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      this.inputDecoration,
      this.size = 12,
      this.maxLineCount = 1,
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.normal,
      this.isLast = false,
      this.obscureText = false,
      this.hintText,
      this.keyboardType = TextInputType.text,
      this.align = TextAlign.start,
      this.color,
      this.prefix,
      this.controller,
      this.onChange,
      this.focusNode,
      this.borderAvaliable = true,
      this.inputFormatters,
      this.value,
      this.disabled = false});

  final TextInputType keyboardType;
  final TextEditingController? controller;
  final InputDecoration? inputDecoration;
  final bool isLast, obscureText, borderAvaliable, disabled;
  final double size;
  final String? hintText;
  final Color? color;
  final TextAlign align;
  final String? value;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Widget? prefix;
  final int? maxLineCount;
  final Function(String)? onChange;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      initialValue: value,
      controller: controller,
      obscureText: obscureText,
      readOnly: disabled,
      keyboardType: keyboardType,
      inputFormatters: [],
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onChanged: onChange,
      textAlign: align,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          decoration: TextDecoration.none,
          color: color ?? AppTheme.textColor,
          fontSize: size,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
        ),
      ),
      maxLines: maxLineCount,
      decoration: inputDecoration ??
          InputDecoration(
            prefix: prefix,
            hintText: hintText,
            hintStyle: TextStyle(
                color: color ?? AppTheme.textColor.withOpacity(.6),
                fontStyle: FontStyle.italic),
            filled: false,
            border: borderAvaliable ? null : InputBorder.none,
            enabledBorder: borderAvaliable
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.firstColor.withOpacity(.3),
                    ),
                  )
                : null,
            focusedBorder: borderAvaliable
                ? UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.firstColor.withOpacity(1),
                    ),
                  )
                : null,
          ),
    );
  }
}
