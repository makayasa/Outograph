import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outograph/app/components/default_placeholder.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/components/my_custom_painter.dart';
import 'package:outograph/app/config/constants.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/helpers/text_align_helper.dart';
import 'package:outograph/app/models/draw_pont.dart';
import 'package:outograph/app/models/gif_widget_data_models.dart';
import 'package:outograph/app/models/image_widget_data_models.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../../../models/text_widget_data_models.dart';

class CanvasItem extends GetView<CanvasController> {
  const CanvasItem({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    if (controller.widgetsData[index]['type'] == CanvasItemType.BACKGROUND) {
      return Container(
        // color: Colors.amber,
        height: double.infinity,
        width: double.infinity,
        child: DefText(controller.widgetsData[index]['data']).normal,
      );
    }
    if (controller.widgetsData[index]['type'] == CanvasItemType.IMAGE) {
      var data = ImageWidgetDataModels.fromJson(controller.widgetsData[index]['data']);
      File imageFile = File.fromUri(Uri.parse(data.path));
      // var a = imageFile.readAsBytesSync();
      return Obx(
        () {
          return IgnorePointer(
            ignoring: controller.botNavIndex.value == 4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  key: controller.listGlobalKey[index],
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: Get.width - 100,
                    // minHeight: 400,
                    // minWidth: Get.width - 100,
                  ),
                  child: Image.file(
                    imageFile,
                    // opacity: index == 1 ? AlwaysStoppedAnimation(.5) : null,
                    gaplessPlayback: true,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    },
                    // fit: BoxFit.cover,
                  ),
                ),
                Visibility(
                  visible: controller.widgetsData[index]['edit_mode'],
                  child: Positioned(
                    right: -10,
                    top: -10,
                    child: Transform.scale(
                      scale: 1 / controller.widgetsData[index]['scale'],
                      child: GestureDetector(
                        onTap: () {
                          logKey('rotate onTap');
                          controller.widgetsData[index]['can_rotate'] = !controller.widgetsData[index]['can_rotate'];
                          controller.widgetsData.refresh();
                        },
                        child: Material(
                          elevation: 5,
                          shape: CircleBorder(),
                          child: Container(
                            height: 35,
                            width: 35,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: controller.widgetsData[index]['can_rotate'] ? kBgWhite : kInactiveColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/icons/rotate.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.widgetsData[index]['edit_mode'],
                  child: Positioned(
                    right: -10,
                    bottom: -10,
                    child: Transform.scale(
                      scale: 1 / controller.widgetsData[index]['scale'],
                      child: GestureDetector(
                        onTap: () {
                          logKey('resize onTap');
                          controller.widgetsData[index]['can_resize'] = !controller.widgetsData[index]['can_resize'];
                          controller.widgetsData.refresh();
                        },
                        child: Material(
                          elevation: 5,
                          shape: CircleBorder(),
                          child: Container(
                            height: 35,
                            width: 35,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: controller.widgetsData[index]['can_resize'] ? kBgWhite : kInactiveColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/icons/resize.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    // Opaque targets can be hit by hit tests, causing them to both receive events within their bounds and prevent targets visually behind them from also receiving events.
    // Translucent targets both receive events within their bounds and permit targets visually behind them to also receive events.
    if (controller.widgetsData[index]['type'] == CanvasItemType.GIF) {
      var data = GifWidgetDataModels.fromJson(controller.widgetsData[index]['data']);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            key: controller.listGlobalKey[index],
            child: CachedNetworkImage(
              // imageUrl: controller.widgetsData[index]['data']['url'],
              imageUrl: data.url,
              httpHeaders: {'accept': 'image/*'},
              placeholder: (context, url) {
                return DefaultPlaceholder(
                  height: 70,
                  width: 70,
                );
              },
            ),
          ),
          Visibility(
            visible: controller.widgetsData[index]['edit_mode'],
            child: Positioned(
              right: -10,
              top: -10,
              child: Transform.scale(
                scale: 1 / controller.widgetsData[index]['scale'],
                child: GestureDetector(
                  onTap: () {
                    logKey('rotate onTap');
                    controller.widgetsData[index]['can_rotate'] = !controller.widgetsData[index]['can_rotate'];
                    controller.widgetsData.refresh();
                  },
                  child: Material(
                    elevation: 5,
                    shape: CircleBorder(),
                    child: Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: controller.widgetsData[index]['can_rotate'] ? kBgWhite : kInactiveColor,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icons/rotate.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: controller.widgetsData[index]['edit_mode'],
            child: Positioned(
              right: -10,
              bottom: -10,
              child: Transform.scale(
                scale: 1 / controller.widgetsData[index]['scale'],
                child: GestureDetector(
                  onTap: () {
                    logKey('resize onTap');
                    controller.widgetsData[index]['can_resize'] = !controller.widgetsData[index]['can_resize'];
                    controller.widgetsData.refresh();
                  },
                  child: Material(
                    elevation: 5,
                    shape: CircleBorder(),
                    child: Container(
                      height: 35,
                      width: 35,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: controller.widgetsData[index]['can_resize'] ? kBgWhite : kInactiveColor,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icons/resize.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (controller.widgetsData[index]['type'] == CanvasItemType.TEXT) {
      // var canvas = CanvasItemModels.fromJson(controller.widgetsData[index]);
      var data = TextWidgetDataModelsOld.fromJson(controller.widgetsData[index]['data']).obs;
      return GetX<CanvasController>(
        init: CanvasController(),
        builder: (ctrl) {
          var textStyle = GoogleFonts.getFont(
            data.value.fontFamily!,
            textStyle: TextStyle(
              fontSize: data.value.fontSize,
              fontWeight: data.value.isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: data.value.isItalic ? FontStyle.italic : FontStyle.normal,
              decoration: data.value.isUnderline ? TextDecoration.underline : TextDecoration.none,
              height: data.value.lineHeight,
              color: Color(data.value.color),
            ),
          );
          var textAlign = TextAlign.start;
          if (data.value.textAlign == TextAlignHelper.CENTER) {
            textAlign = TextAlign.center;
          } else if (data.value.textAlign == TextAlignHelper.LEFT) {
            textAlign = TextAlign.left;
          } else if (data.value.textAlign == TextAlignHelper.RIGHT) {
            textAlign = TextAlign.right;
          } else if (data.value.textAlign == TextAlignHelper.END) {
            textAlign = TextAlign.end;
          } else if (data.value.textAlign == TextAlignHelper.CENTER) {
            textAlign = TextAlign.start;
          }
          if (controller.widgetsData[index]['edit_mode']) {
            // controller.isTextEditMode.value = true;
            return IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kInactiveColor,
                  ),
                ),
                child: TextFormField(
                  initialValue: data.value.text,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: textStyle,
                  textAlign: textAlign,
                  onChanged: (value) {
                    controller.tempEditingText.value = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    controller.widgetsData[index]['data']['text'] = value;
                    controller.widgetsData[index]['edit_mode'] = false;
                    controller.widgetsData.refresh();
                    logKey('data', controller.widgetsData[index]['data']);
                  },
                ),
              ),
            );
          } else {
            return Container(
              child: Text(
                data.value.text,
                textAlign: textAlign,
                style: textStyle,
              ),
            );
          }
        },
      );
    }
    if (controller.widgetsData[index]['type'] == CanvasItemType.BRUSH_BASE) {
      return Obx(
        () => IgnorePointer(
          ignoring: controller.botNavIndex.value != 4 || controller.isEyeDrop.isTrue,
          child: GestureDetector(
            // behavior: HitTestBehavior.deferToChild,
            // onTap: () {
            //   logKey('onTap brush Base');
            // },
            onPanStart: controller.botNavIndex.value == 4
                ? (details) {
                    controller.drawPoint.add(
                      DrawPoint(
                        isDraw: controller.isDraw.value,
                        dx: details.localPosition.dx,
                        dy: details.localPosition.dy,
                        style: 'stroke',
                        stroke: controller.stroke.value,
                        color: controller.brushColor.value,
                      ),
                    );
                  }
                : null,
            onPanUpdate: controller.botNavIndex.value == 4
                ? (details) {
                    controller.drawPoint.add(
                      DrawPoint(
                        isDraw: controller.isDraw.value,
                        dx: details.localPosition.dx,
                        dy: details.localPosition.dy,
                        style: 'stroke',
                        stroke: controller.stroke.value,
                        color: controller.brushColor.value,
                      ),
                    );
                  }
                : null,
            onPanEnd: controller.botNavIndex.value == 4
                ? (details) {
                    controller.drawPoint.add(null);
                    controller.saveState(type: CanvasItemType.BRUSH);
                  }
                : null,
            child: Visibility(
              visible: true,
              child: Container(
                // height: Get.height - controller.bait.value,
                height: Get.height,
                width: Get.width,
                child: CustomPaint(
                  painter: MyCustomPainter(
                    // color: 0xFF191508,
                    drawPoints: controller.drawPoint.value.cast<DrawPoint?>(),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: Get.height - 75,
      width: Get.width,
      // height: 25,
      // width: 25,
      color: Color(
        controller.widgetsData[index]['color'],
      ).withOpacity(1),
      child: Center(
        child: Text('$index asd'),
      ),
    );
  }
}
