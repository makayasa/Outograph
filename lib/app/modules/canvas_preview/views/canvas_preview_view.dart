import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/canvas_item_global.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/image_model/image_widget_model.dart';

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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: controller.sc,
            child: Column(
              children: [
                //* Profile
                Stack(
                  // fit: StackFit.expand,
                  children: [
                    Container(
                      key: controller.profileKey,
                      decoration: BoxDecoration(
                          // color: Colors.grey,
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
                                  DefText(
                                    '128',
                                    fontWeight: FontWeight.bold,
                                  ).semilarge,
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
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/profile.png',
                                  ),
                                ),
                                // child: Image.asset(
                                //   'assets/images/default_picture.jpeg',
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              SizedBox(width: 25),
                              Column(
                                children: [
                                  DefText('Followers').normal,
                                  SizedBox(height: 5),
                                  DefText(
                                    '93',
                                    fontWeight: FontWeight.bold,
                                  ).semilarge,
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          //* name
                          DefText(
                            'miss_chan',
                            fontWeight: FontWeight.bold,
                          ).normal,
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
                          SizedBox(height: 10),
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
                          SizedBox(height: 15),
                        ],
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
                                          var url = data.url;
                                          return Container(
                                            child: Image.file(
                                              File.fromUri(
                                                Uri.parse(url),
                                              ),
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
                                          var url = data.url;
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
