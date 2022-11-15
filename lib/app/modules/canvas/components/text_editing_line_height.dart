import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';

import '../../../config/constants.dart';

class TextEditingLineHeight extends GetView<CanvasController> {
  const TextEditingLineHeight({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 35),
          DefText(
            'Font Size',
          ).semilarge,
          SizedBox(height: 10),
          DefText(
            '${controller.widgetsData[index]['data']['lineHeight']} px',
            fontWeight: FontWeight.bold,
          ).semilarge,
          SizedBox(height: 35),
          Slider(
            value: controller.widgetsData[index]['data']['lineHeight'],
            onChanged: (value) {
              controller.widgetsData[index]['data']['lineHeight'] = value.toPrecision(2);
              controller.widgetsData.refresh();
            },
            min: 1.0,
            max: 4.0,
            thumbColor: kBgBlack,
            activeColor: kBgBlack,
            inactiveColor: kInactiveColor.withOpacity(
              0.4,
            ),
          ),
        ],
      ),
    );
  }
}
