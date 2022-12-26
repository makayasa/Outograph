import 'dart:io';

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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.sc,
            child: Column(
              children: [
                //* Profile
                Container(
                  key: controller.profileKey,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 5),
                      //* following row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              DefText('Following').normal,
                              SizedBox(height: 5),
                              DefText('128').normal,
                            ],
                          ),
                          SizedBox(width: 25),
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(width: 25),
                          Column(
                            children: [
                              DefText('Followers').normal,
                              SizedBox(height: 5),
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            DefText('63 Impressions').normal,
                            Spacer(),
                            DefText('Post').normal,
                          ],
                        ),
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
                    // color: Colors.amber,
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
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller.isAnimated.isFalse) {
                                            controller.onTep(
                                              index: idx,
                                            );
                                          }
                                        },
                                        child: Hero(
                                          tag: idx,
                                          child: CanvasItemGlobal(
                                            data: controller.canvasItems[idx].toJson(),
                                            isLocal: true,
                                          ),
                                        ),
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
          Obx(
            () {
              return AnimatedPositioned(
                // duration: controller.isInPosition.isFalse ? Duration(milliseconds: 1) : Duration(seconds: 2),
                // duration: controller.duration,
                duration: controller.isInPosition.isFalse ? Duration(milliseconds: 50) : controller.duration,
                height: controller.zoomHeight.value,
                width: controller.zoomWidth.value,
                top: controller.animatedY.value,
                left: controller.animatedX.value,
                onEnd: () {
                  if (controller.isInPosition.isFalse) {
                    controller.isInPosition.value = true;
                    controller.isVisible.value = true;
                  } else {
                    controller.isAnimated.value = false;
                    controller.isVisible.value = false;
                    Get.dialog(
                      Dialog(
                        child: Container(
                          child: Image.file(
                            File.fromUri(
                              Uri.parse(
                                controller.url.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                child: IgnorePointer(
                  child: Visibility(
                    // visible: !controller.isVisible.value,
                    visible: controller.url.value != '' && controller.isVisible.value,
                    child: Container(
                      width: 250,
                      child: Image.file(
                        File.fromUri(
                          Uri.parse(
                            controller.url.value,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
