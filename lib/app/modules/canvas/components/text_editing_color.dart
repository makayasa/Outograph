import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outograph/app/config/constants.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';

class TextEditingColor extends GetView<CanvasController> {
  const TextEditingColor({super.key, required this.idx});
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: textColorList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.widgetsData[idx]['data']['color'] = textColorList[index].value;
                controller.widgetsData.refresh();
              },
              child: Container(
                height: 25,
                width: 25,
                color: textColorList[index],
                // color: kBgBlack,
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 15),
            EyedropperButton(
              onTap: () {
                controller.isEyeDrop.value = true;
              },
              onColor: (color) {
                controller.widgetsData[idx]['data']['color'] = color.value;
                controller.widgetsData.refresh();
                controller.isEyeDrop.value = false;
              },
              child: Image.asset(
                'assets/icons/eyedropper.png',
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                controller.showColorPicker(isTextColor: true);
              },
              child: Container(
                height: 38,
                width: 38,
                child: Image.asset(
                  'assets/icons/color-wheel.png',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
