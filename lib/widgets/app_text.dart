import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AppText extends StatelessWidget {
  double size;
  final String text;
  final Color? color;
  final TextAlign align;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final int? maxLineCount;

  AppText(
      {Key? key,
      this.size = 12,
      this.maxLineCount = 5,
      required this.text,
      this.fontWeight = FontWeight.normal,
      this.fontStyle = FontStyle.normal,
      this.align = TextAlign.start,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLineCount,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(
            decoration: TextDecoration.none,
            color: color ?? AppTheme.textColor,
            fontSize: size,
            fontWeight: fontWeight,
            fontStyle: fontStyle),
      ),
    );
  }
}

class App_Rich_Text extends StatefulWidget {
  const App_Rich_Text(
      {super.key,
      required this.text,
      this.size = 12,
      this.maxLineCount = 5,
      this.fontWeight = FontWeight.normal,
      this.fontStyle = FontStyle.normal,
      this.align = TextAlign.start,
      this.color});
  final double size;
  final List<String> text;
  final Color? color;
  final TextAlign align;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final int? maxLineCount;
  @override
  State<App_Rich_Text> createState() => _App_Rich_TextState();
}

class _App_Rich_TextState extends State<App_Rich_Text> {
  TextStyle? _normalTextStyle, _boldTextStyle;

  @override
  void initState() {
    setState(() {
      _normalTextStyle = GoogleFonts.montserrat(
        textStyle: TextStyle(
            decoration: TextDecoration.none,
            color: widget.color ?? AppTheme.textColor,
            fontSize: widget.size,
            fontWeight: widget.fontWeight,
            fontStyle: widget.fontStyle),
      );
      _boldTextStyle = GoogleFonts.montserrat(
        textStyle: TextStyle(
            decoration: TextDecoration.none,
            color: widget.color ?? AppTheme.textColor,
            fontSize: widget.size,
            fontWeight: FontWeight.bold,
            fontStyle: widget.fontStyle),
      );
    });

    // TODO: implement initState
    super.initState();
  }

  List<TextSpan> createTextSpan() {
    List<TextSpan> returns = [];
    for (var i = 1; i < widget.text.length; i++) {
      returns.add(
        TextSpan(
            text: widget.text[i],
            style: i % 2 == 1 ? _boldTextStyle : _normalTextStyle),
      );
    }
    return returns;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.text.length == 1) {
      return AppText(
        text: widget.text[0],
        maxLineCount: 999,
      );
    } else {
      return RichText(
        textAlign: widget.align,
        maxLines: widget.maxLineCount,
        text: TextSpan(
            text: widget.text[0],
            style: _normalTextStyle,
            children: createTextSpan()),
      );
    }
  }
}

// ignore: must_be_immutable
class AppLargeText extends StatelessWidget {
  double size;
  final String text;
  final Color? color;
  final TextAlign align;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final int maxLineCount;
  AppLargeText(
      {Key? key,
      this.size = 16,
      this.maxLineCount = 2,
      this.fontStyle = FontStyle.normal,
      this.fontWeight = FontWeight.bold,
      required this.text,
      this.align = TextAlign.start,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLineCount,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          decoration: TextDecoration.none,
          color: color ?? AppTheme.textColor,
          fontSize: size,
          fontStyle: fontStyle,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
