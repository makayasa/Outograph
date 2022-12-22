import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outograph/app/helpers/text_align_helper.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';

import '../../../config/constants.dart';
import '../../../models/text_widget_data_models.dart';

class TextEditingAlignment extends GetView<CanvasController> {
  const TextEditingAlignment({
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
                    controller.widgetsData[idx]['data']['textAlign'] = TextAlignHelper.START;
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/align-left.png',
                      color: data.value.textAlign == TextAlignHelper.START ? null : kInactiveColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.widgetsData[idx]['data']['textAlign'] = TextAlignHelper.CENTER;
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/align-center.png',
                      color: data.value.textAlign == TextAlignHelper.CENTER ? null : kInactiveColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.widgetsData[idx]['data']['textAlign'] = TextAlignHelper.END;
                    controller.widgetsData.refresh();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'assets/icons/align-right.png',
                      color: data.value.textAlign == TextAlignHelper.END ? null : kInactiveColor,
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
