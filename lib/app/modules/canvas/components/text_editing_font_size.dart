import 'package:Outograph/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../components/default_text.dart';
import '../../../config/constants.dart';

class TextEditingFontSize extends GetView<CanvasController> {
  const TextEditingFontSize({
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
            '${controller.widgetsData[index]['data']['fontSize']} px',
            fontWeight: FontWeight.bold,
          ).semilarge,
          SizedBox(height: 35),
          Slider(
            value: controller.widgetsData[index]['data']['fontSize'],
            onChanged: (value) {
              controller.widgetsData[index]['data']['fontSize'] = value.toPrecision(2);
              controller.widgetsData.refresh();
            },
            min: 1.0,
            max: 50.0,
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
