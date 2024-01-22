import 'package:envanterimservetim/core/constants/sizeconfig.dart';
import 'package:envanterimservetim/core/constants/theme.dart';
import 'package:flutter/material.dart';

class NetworkContainer extends StatefulWidget {
  const NetworkContainer(
      {super.key,
      required this.imageUrl,
      this.child,
      this.fit = BoxFit.cover,
      this.borderRadius});

  @override
  _NetworkContainerState createState() => _NetworkContainerState();
  final NetworkImage imageUrl;
  final Widget? child;
  final BoxFit fit;
  final BorderRadius? borderRadius;
}

class _NetworkContainerState extends State<NetworkContainer> {
  bool _isLoading = true;
  ImageProvider? _imageProvider;
  BorderRadius? borderRadius;
  @override
  void initState() {
    super.initState();

    _imageProvider = widget.imageUrl;

    _imageProvider!.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((info, synchronousCall) {
        if (mounted) {
          setState(() {
            _isLoading = false; // Yükleme tamamlandı
          });
        }
      }),
    );
    if (widget.borderRadius == null) {
      setState(() {
        borderRadius = defaultRadius;
      });
    } else {
      setState(() {
        borderRadius = widget.borderRadius;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: AppTheme.textColor,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: _imageProvider!, fit: widget.fit),
                borderRadius: borderRadius,
              ),
              child: widget.child,
            ),
    );
  }
}
