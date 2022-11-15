import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:outograph/app/config/constants.dart';

class BrushItem extends StatelessWidget {
  const BrushItem({
    super.key,
    this.image,
    this.border,
    required this.color,
    required this.onTap,
  });
  final String? image;
  final Color color;
  final Function() onTap;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          border: border,
          borderRadius: kDefaultBorderRadius,
          color: color,
        ),
        child: image != null
            ? Image.asset(
                image!,
              )
            : null,
      ),
    );
  }
}
