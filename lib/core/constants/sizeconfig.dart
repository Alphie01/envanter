import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getPaddingScreenTopHeight() {
  MediaQueryData mediaQueryData = SizeConfig._mediaQueryData;
  return mediaQueryData.padding.top;
}

double getPaddingScreenBottomHeight() {
  MediaQueryData mediaQueryData = SizeConfig._mediaQueryData;
  return mediaQueryData.padding.bottom;
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

double paddingHorizontal = 15.0;

EdgeInsets paddingZero = EdgeInsets.zero;

BorderRadius defaultRadius = BorderRadius.circular(paddingHorizontal);

class BarcodeReader {
  static Future<String> scanQRBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.QR, // Sadece barkodları tara
    );

    return barcodeScanResult;
  }

  static Future<String> scanBarcode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#00FFFFFF', // Tarama ekranının arka plan rengi
      'İptal', // İptal butonu metni
      true, // Kamera flaşını kullanma
      ScanMode.BARCODE, // Sadece barkodları tara
    );

    return barcodeScanResult;
  }
}
