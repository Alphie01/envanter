import 'package:envanterimservetim/core/httpRequests/http.dart';
import 'package:flutter/material.dart';

class Platforms {
  final String platformName;
  final String platformId;
  final NetworkImage platformImg;
  final String platformColor;
  final String platformApiURL;

  Platforms(
      {required this.platformName,
      required this.platformId,
      this.platformColor = '#000000',
      required this.platformImg,
      required this.platformApiURL});
  static List<Platforms> publishPlatforms = [];
  static List<Platforms> allPlatforms = [];

  static Future fetchPlatformInfos() async {
    List<dynamic> returns = await HTTP_Requests.getHttp(['fetchPlatforms=ok']);
    allPlatforms = Platforms.createPlatformsList(returns);
  }

  static Platforms createPlatforms(String platform_id, String platform_name,
      String platform_Img, String? platform_ApiURL, String platform_color) {
    return Platforms(
        platformName: platform_name,
        platformId: platform_id,
        platformColor: platform_color,
        platformImg: NetworkImage(platform_Img),
        platformApiURL: platform_ApiURL ?? 'null');
  }

  static List<Platforms> createPlatformsList(List json) {
    List<Platforms> _return = [];

    for (var element in json) {
      _return.add(createPlatforms(
          element['platform_id'],
          element['platform_name'],
          element['platform_color'],
          element['platform_Img'],
          element['platform_ApiURL']));
    }

    return _return;
  }
}
