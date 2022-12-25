import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/canvas_item_global.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../../../config/constants.dart';
import '../controllers/canvas_preview_controller.dart';

class CanvasPreviewView extends GetView<CanvasPreviewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: DefText(
          'Preview Post',
          fontWeight: FontWeight.bold,
        ).large,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: kBgBlack,
          ),
        ),
        actions: [
          Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //* Profile
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //* following row
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          DefText('Following').normal,
                          SizedBox(height: 10),
                          DefText('128').normal,
                        ],
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 75,
                        width: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          DefText('Followers').normal,
                          SizedBox(height: 10),
                          DefText('128').normal,
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //* name
                  DefText('miss_chan').normal,
                  SizedBox(height: 10),
                  DefText('Misa Hana Lestari').normal,
                  SizedBox(height: 20),
                  //* impression
                  Row(
                    children: [
                      DefText('63 Impressions').normal,
                      Spacer(),
                      DefText('Post').normal,
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),

                  //* Pinned, canvas, tag
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DefText('Pinned').normal,
                        DefText('Canvas').normal,
                        DefText('Tag').normal,
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            //* Canvas
            Obx(
              () => Container(
                height: 603.4285714285714,
                width: 411.42857142857144,
                color: Colors.amber,
                child: Stack(
                  fit: StackFit.expand,
                  children: controller.canvasItems
                      .asMap()
                      .map(
                        (idx, value) {
                          logKey('length', controller.canvasItems.length);
                          return MapEntry(
                            idx,
                            Positioned(
                              left: controller.canvasItems[idx].x_axis,
                              top: controller.canvasItems[idx].y_axis,
                              child: Transform.rotate(
                                angle: controller.canvasItems[idx].rotation,
                                child: Transform.scale(
                                  scale: controller.canvasItems[idx].scale,
                                  child: CanvasItemGlobal(
                                    data: controller.canvasItems[idx].toJson(),
                                    isLocal: true,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .values
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
