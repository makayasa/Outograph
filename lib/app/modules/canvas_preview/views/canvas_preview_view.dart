import 'dart:io';
import 'dart:ui';

import 'package:Outograph/app/components/canvas_item_global.dart';
import 'package:Outograph/app/components/default_text.dart';
import 'package:Outograph/app/components/profile_header.dart';
import 'package:Outograph/app/helpers/canvas_helper.dart';
import 'package:Outograph/app/models/image_model/image_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          Row(
            children: [
              Material(
                color: kBgBlack,
                borderRadius: BorderRadius.circular(2),
                child: InkWell(
                  onTap: () {
                    controller.createPost();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: DefText(
                      'Finish',
                      color: kBgWhite,
                    ).normal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createPost();
        },
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.sc,
            child: Column(
              children: [
                Stack(
                  children: [
                    //* overlay profile
                    Container(
                      key: controller.profileKey,
                      decoration: BoxDecoration(
                          // color: Colors.grey,
                          ),
                      //* Profile
                      child: ProfileHeader(
                        isPreview: true,
                      ),
                    ),
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.25,
                        child: Container(
                          height: double.infinity,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                //* Canvas
                Obx(
                  () => Container(
                    height: controller.canvasHeight.value,
                    // height: 300,
                    // height: 603.4285714285714,
                    // width: 411.42857142857144,
                    // color: Colors.amber,
                    child: Stack(
                      fit: StackFit.expand,
                      children: controller.canvasItems
                          .asMap()
                          .map(
                            (idx, value) {
                              return MapEntry(
                                idx,
                                Positioned(
                                  left: controller.canvasItems[idx].type == CanvasItemType.BRUSH ? 0.0 : controller.canvasItems[idx].x_axis,
                                  top: controller.canvasItems[idx].type == CanvasItemType.BRUSH
                                      ? 0.0
                                      : controller.canvasItems[idx].y_axis - controller.canvasTop.value,
                                  child: Transform.rotate(
                                    angle: controller.canvasItems[idx].type == CanvasItemType.BRUSH ? 0.0 : controller.canvasItems[idx].rotation,
                                    child: Transform.scale(
                                      scale: controller.canvasItems[idx].type == CanvasItemType.BRUSH ? 1.0 : controller.canvasItems[idx].scale,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller.isAnimated.isFalse && controller.canvasItems[idx].type == CanvasItemType.IMAGE) {
                                            controller.onTep(
                                              index: idx,
                                            );
                                          }
                                        },
                                        child: CanvasItemGlobal(
                                          data: controller.canvasItems[idx].toJson(),
                                          isLocal: true,
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
          //* dialog untuk image
          GetX<CanvasPreviewController>(
            builder: (ctrl) {
              PageController pageController = PageController(
                initialPage: controller.checkIndex(canvasItemsIndex: controller.tappedIndex.value) ?? 0,
              );
              return AnimatedPositioned(
                duration: !controller.isInPosition.value ? Duration(microseconds: 1) : controller.duration,
                height: controller.zoomHeight.value,
                width: controller.zoomWidth.value,
                top: controller.animatedY.value,
                left: controller.animatedX.value,
                onEnd: () async {
                  if (controller.isInPosition.isFalse) {
                    controller.isInPosition.value = true;
                    controller.isVisible.value = true;
                  } else {
                    controller.isAnimated.value = false;
                    controller.isVisible.value = false;
                    controller.isInPosition.value = false;
                    await Get.dialog(
                      transitionDuration: Duration(milliseconds: 250),
                      transitionCurve: Curves.easeInOutCirc,
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.symmetric(vertical: 25),
                          child: Container(
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  Obx(
                                    () => Container(
                                      constraints: BoxConstraints(maxHeight: Get.height * 0.75),
                                      child: PageView.builder(
                                        itemCount: controller.canPopupImages.length,
                                        // controller: controller.dialogPageController,
                                        controller: pageController,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          var data = ImageWidgetModel.fromJson(controller.canPopupImages[index].toJson());
                                          var url = data.path;
                                          return Container(
                                            child: Image.file(
                                              File(url),
                                              // File.fromUri(
                                              //   Uri.parse(url),
                                              // ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Obx(
                                    () => Container(
                                      height: 100,
                                      child: ListView.separated(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        shrinkWrap: true,
                                        itemCount: controller.canPopupImages.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(
                                          parent: AlwaysScrollableScrollPhysics(),
                                        ),
                                        separatorBuilder: (context, index) => SizedBox(
                                          width: 5,
                                        ),
                                        itemBuilder: (context, index) {
                                          // logKey('items $index', controller.canPopupImages[index]);
                                          var data = ImageWidgetModel.fromJson(controller.canPopupImages[index].toJson());
                                          var url = data.path;
                                          // logKey('uri', uri);
                                          return GestureDetector(
                                            onTap: () {
                                              // controller.url.value = url;
                                              pageController.animateToPage(
                                                index,
                                                duration: controller.duration,
                                                curve: Curves.easeInOutCirc,
                                              );
                                            },
                                            child: Container(
                                              // width: 75,
                                              color: Colors.amber,
                                              child: Image.file(
                                                File.fromUri(
                                                  Uri.parse(url),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    pageController.dispose();
                  }
                },
                child: IgnorePointer(
                  child: AnimatedCrossFade(
                    duration: Duration(milliseconds: 250),
                    layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
                      return topChild;
                    },
                    crossFadeState: controller.isVisible.value ? CrossFadeState.showFirst : CrossFadeState.showFirst,
                    firstChild: Opacity(
                      opacity: controller.isInPosition.value && controller.url.value != '' ? 1 : 0,
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
                    secondChild: Container(
                      height: 100,
                      width: 100,
                      color: Colors.amber,
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
