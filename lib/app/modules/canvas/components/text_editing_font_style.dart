import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';

import '../../../config/constants.dart';
import '../../../models/text_widget_data_models.dart';

class TextEditingFontStyle extends GetView<CanvasController> {
  const TextEditingFontStyle({
    super.key,
    required this.idx,
  });

  final int idx;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var data = TextWidgetDataModelsOld.fromJson(controller.widgetsData[idx]['data']).obs;
        return Container(
          child: Center(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.widgetsData[idx]['data']['isBold'] = !controller.widgetsData[idx]['data']['isBold'];
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/bold.png',
                      color: !data.value.isBold ? kInactiveColor : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.widgetsData[idx]['data']['isItalic'] = !controller.widgetsData[idx]['data']['isItalic'];
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/italic.png',
                      color: !data.value.isItalic ? kInactiveColor : null,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.widgetsData[idx]['data']['isUnderline'] = !controller.widgetsData[idx]['data']['isUnderline'];
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/underline.png',
                      color: !data.value.isUnderline ? kInactiveColor : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
