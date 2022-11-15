import 'package:flutter/material.dart';

import '../config/constants.dart';

class DefaultPlaceholder extends StatelessWidget {
  DefaultPlaceholder({
    this.borderRadius,
    this.imageAsset,
    required this.height,
    required this.width,
    this.fit = BoxFit.cover,
  });

  final BorderRadius? borderRadius;
  final String? imageAsset;
  final double height;
  final double width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius ?? kDefaultBorderRadius10,
        child: Image.asset(
          imageAsset ?? kDefaultPicture,
          fit: fit,
        ),
      ),
    );
  }
}
