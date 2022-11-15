import 'package:flutter/material.dart';
import 'package:outograph/app/config/constants.dart';

class TextEditingItems extends StatelessWidget {
  const TextEditingItems({
    super.key,
    required this.assets,
    this.isActive = false,
    required this.onTap,
  });
  final String assets;
  final bool isActive;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? kBgBlack : kInactiveColor.withOpacity(0.4),
              width: 2.5,
              // style: isActive ? BorderStyle.solid : BorderStyle.none,
            ),
          ),
          // border: Border.all(
          //   color: kBgBlack,
          // ),
        ),
        child: Center(
          child: Image.asset(
            // 'assets/icons/font.png',
            assets,
            height: 20,
          ),
        ),
      ),
    );
  }
}
