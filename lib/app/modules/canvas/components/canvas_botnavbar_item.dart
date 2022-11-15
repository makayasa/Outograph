import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../components/default_text.dart';

class CanvasBotnavbarItem extends StatelessWidget {
  const CanvasBotnavbarItem({
    super.key,
    required this.asset,
    required this.text,
    required this.color,
    required this.onTap,
  });
  final String asset;
  final String text;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // splashColor: Colors.grey,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: 2, bottom: 1),
          width: 65,
          child: Column(
            children: [
              Container(
                height: 24,
                width: 24,
                child: Image.asset(
                  asset,
                  color: color,
                ),
              ),
              SizedBox(height: 5),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: DefText(
                        text,
                        textAlign: TextAlign.center,
                        color: color,
                      ).semiSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
