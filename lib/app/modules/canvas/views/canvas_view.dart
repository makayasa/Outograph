import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/components/mx_gesture_detector.dart';
import 'package:outograph/app/components/overlay_widget.dart';
import 'package:outograph/app/config/constants.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/helpers/text_size_helper.dart';
import 'package:outograph/app/modules/canvas/components/brush_item.dart';
import 'package:outograph/app/modules/canvas/components/color_item.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_alignment.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_color.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_font_size.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_font_style.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_fonts.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_items.dart';
import 'package:outograph/app/modules/canvas/components/text_editing_line_height.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utils/function_utils.dart';
import '../../../models/canvas_widget_model.dart';
import '../../../models/text_widget_data_models.dart';
import '../components/canvas_botnavbar_item.dart';
import '../components/canvas_images_list.dart';
import '../components/canvas_item.dart';
import '../controllers/canvas_controller.dart';

class CanvasView extends GetView<CanvasController> {
  @override
  Widget build(BuildContext context) {
    return EyeDrop(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              controller.drawPoint.clear();
            },
            child: Icon(
              Icons.arrow_back,
              color: kBgBlack,
            ),
          ),
          backgroundColor: kBgWhite,
          title: Row(
            children: [
              Obx(
                () => InkWell(
                  onTap: () {
                    // controller.undoBrush();
                    // controller.undo();
                    if (controller.undoStates.isNotEmpty) {
                      controller.undo();
                    }
                  },
                  child: Icon(
                    Icons.undo_rounded,
                    color: controller.undoStates.isEmpty ? kInactiveColor : kBgBlack,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Obx(
                () => InkWell(
                  onTap: () {
                    // controller.redoBrush();
                    // controller.redo();
                    if (controller.redoStates.isNotEmpty) {
                      controller.redo();
                    }
                  },
                  child: Icon(
                    Icons.redo_rounded,
                    color: controller.redoStates.isEmpty ? kInactiveColor : kBgBlack,
                  ),
                ),
              )
            ],
          ),
          actions: [
            Obx(
              () => Visibility(
                visible: controller.isTextEditMode.value || controller.objectEditMode.value,
                child: Row(
                  children: [
                    Material(
                      child: InkWell(
                        onTap: () {
                          if (controller.isTextEditMode.value) {
                            controller.saveText();
                            return;
                          }
                          controller.exitEditMode();
                        },
                        child: Container(
                          height: 28,
                          width: 75,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: kBgBlack,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefText('Done').normal,
                                SizedBox(width: 5),
                                Icon(
                                  Icons.check,
                                  color: kBgBlack,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
        //* floating button
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     controller.addWidget(type: 'container');
        //   },
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Container(
          width: Get.width,
          height: Get.height,
          child: GetX<CanvasController>(
            init: CanvasController(),
            builder: (controller) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      child: Stack(
                        fit: StackFit.expand,
                        children: controller.widgetsData
                            .asMap()
                            .map(
                              (idx, value) {
                                var index = idx;
                                if (controller.widgetsData[0]['type'] == CanvasItemType.BACKGROUND) {
                                  index += 1;
                                }
                                Matrix4 _tempMatrix = Matrix4.identity();
                                Matrix4 _tempTM = Matrix4.identity();
                                Matrix4 _tempSM = Matrix4.identity();
                                Matrix4 _tempRM = Matrix4.identity();

                                return MapEntry(
                                  index,
                                  OverlayWidget(
                                    index: index,
                                    onTap: () {
                                      // if (controller.widgetsData[index]['type'] == CanvasItemType.TEXT) {
                                      //   if (controller.checkTextEditActive()) {
                                      //     Get.snackbar('Alert', 'Please save your current text');
                                      //     return;
                                      //   }
                                      //   if (!controller.widgetsData[index]['edit_mode']) {
                                      //     controller.widgetsData[index]['edit_mode'] = true;
                                      //     controller.isTextEditMode.value = !controller.isTextEditMode.value;
                                      //     controller.widgetsData.refresh();
                                      //   }
                                      //   return;
                                      // }

                                      //* test
                                      bool isEditMode = controller.checkEditMode();
                                      if (!isEditMode) {
                                        //* if text widget
                                        if (controller.widgetsData[index]['type'] == CanvasItemType.TEXT) {
                                          if (controller.checkTextEditActive()) {
                                            Get.snackbar('Alert', 'Please save your current text');
                                            return;
                                          }
                                          if (!controller.widgetsData[index]['edit_mode']) {
                                            controller.widgetsData[index]['edit_mode'] = true;
                                            controller.isTextEditMode.value = !controller.isTextEditMode.value;
                                            controller.widgetsData.refresh();
                                          }
                                          return;
                                        }

                                        controller.objectEditMode.value = true;
                                        controller.widgetsData[index]['edit_mode'] = !controller.widgetsData[index]['edit_mode'];
                                      }
                                      // else {
                                      //   if (controller.widgetsData[index]['edit_mode']) {
                                      //     controller.widgetsData[index]['edit_mode'] = false;
                                      //     controller.objectEditMode.value = false;
                                      //   }
                                      // }
                                      controller.widgetsData.refresh();

                                      // return;
                                      // if (!controller.widgetsData[index]['edit_mode']) {
                                      //   controller.widgetsData[index]['can_rotate'] = false;
                                      //   controller.widgetsData[index]['can_resize'] = false;
                                      // }
                                      // controller.widgetsData.refresh();
                                    },
                                    shouldRotate: controller.widgetsData[index]['can_rotate'] ?? false,
                                    shouldScale: controller.widgetsData[index]['can_resize'] ?? false,
                                    shouldTranslate: controller.widgetsData[index]['can_translate'] ?? true,
                                    callBack: (m, tm, sm, rm) {
                                      _tempMatrix = MxGestureDetector.compose(m, tm, sm, rm);
                                      _tempTM = tm;
                                      _tempSM = sm;
                                      _tempRM = rm;
                                    },
                                    onScaleEnd: (details) {
                                      var decompose = MxGestureDetector.decomposeToValues(_tempMatrix);
                                      if (controller.redoStates.isNotEmpty) {
                                        controller.redoStates.clear();
                                      }

                                      //* for detect is it on the undo state. Needed to control the matrix widget
                                      var _undoState = controller.widgetsData[index]['imageWidgetBool'];

                                      controller.widgetsData[index]['dx'] = decompose.translation.dx;
                                      controller.widgetsData[index]['dy'] = decompose.translation.dy;
                                      controller.widgetsData[index]['scale'] = decompose.scale;
                                      controller.widgetsData[index]['rotation'] = decompose.rotation;
                                      controller.widgetsData[index]['matrix'] = _tempMatrix.storage;
                                      controller.widgetsData[index]['matrix_translation'] = _tempTM.storage;
                                      controller.widgetsData[index]['matrix_scale'] = _tempSM.storage;
                                      controller.widgetsData[index]['matrix_rotation'] = _tempRM.storage;
                                      controller.widgetsData[index]['imageWidgetBool'] = details['bool'];
                                      if (_undoState) {
                                        controller.widgetsData.refresh();
                                      }
                                      controller.saveState();
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      widthFactor: 1,
                                      heightFactor: 1,
                                      child: Container(
                                        height: controller.widgetsData[index]['type'] == CanvasItemType.BRUSH_BASE ? Get.height + 65 : null,
                                        width: controller.widgetsData[index]['type'] == CanvasItemType.BRUSH_BASE ? Get.width + 80 : null,
                                        child: CanvasItem(index: index),
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
                  //* Sliding up panel
                  //* image panel
                  Obx(
                    () => SlidingUpPanel(
                      minHeight: controller.tempMinHeigh.value,
                      maxHeight: Get.height * 0.89,
                      controller: controller.panelImageController,
                      panel: CanvasImagesList(),
                    ),
                  ),

                  //* Edit Mode
                  Obx(
                    () => Visibility(
                      visible: controller.objectEditMode.value,
                      child: Positioned.fill(
                        bottom: 64,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: kInactiveColor,
                                  ),
                                ),
                              ),
                              height: 70,
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.moveDownWidget();
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          'assets/icons/layer-up.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.moveUpWidget();
                                      },
                                      child: Container(
                                        child: Image.asset(
                                          'assets/icons/layer-down.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  VerticalDivider(
                                    indent: 10,
                                    endIndent: 10,
                                    color: kBgBlack,
                                  ),
                                  Obx(
                                    () {
                                      var idx = controller.getIndexActiveEditMode();
                                      var canRorate = controller.widgetsData[idx]['can_rotate'];
                                      logKey('canRotate', canRorate);
                                      return Expanded(
                                        child: Container(
                                          child: Image.asset(
                                            'assets/icons/rotate-object.png',
                                            color: !canRorate ? kInactiveColor : kBgBlack,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Obx(
                                    () {
                                      var idx = controller.getIndexActiveEditMode();
                                      return Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            var temp = CanvasItemModels.fromJson(controller.widgetsData[idx]).obs;
                                            // var a = Matrix4.fromFloat64List(temp.matrix);
                                            // var zxc = Matrix4Transform.from(Matrix4.fromFloat64List(temp.matrix)).rotateDegrees(
                                            //   45,
                                            //   origin: Offset(
                                            //     Get.width / 2,
                                            //     Get.height / 2,
                                            //   ),
                                            // );
                                            var zxc = Matrix4Transform.from(Matrix4.fromFloat64List(temp.value.matrix)).rotate(
                                              -temp.value.rotation,
                                              origin: Offset(
                                                Get.width / 2,
                                                Get.height / 2,
                                              ),
                                            );
                                            // logKey('temp', temp.toJson());

                                            controller.widgetsData[idx]['matrix'] = zxc.matrix4.storage;
                                            controller.widgetsData[idx]['imageWidgetBool'] = true;
                                            controller.widgetsData.refresh();
                                            // logKey('matrix temp', temp.matrix);
                                            // logKey('matrix temp after rotate', a.storage);
                                          },
                                          child: Container(
                                            child: Image.asset(
                                              'assets/icons/reset-rotate.png',
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  VerticalDivider(
                                    indent: 10,
                                    endIndent: 10,
                                    color: kBgBlack,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Image.asset(
                                        'assets/icons/magnet.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      child: Image.asset(
                                        'assets/icons/crop.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  VerticalDivider(
                                    indent: 10,
                                    endIndent: 10,
                                    color: kBgBlack,
                                  ),
                                  Obx(
                                    () {
                                      var idx = controller.getIndexActiveEditMode();
                                      var temp = CanvasItemModels.fromJson(controller.widgetsData[idx]).obs;
                                      return GestureDetector(
                                        onTap: () {
                                          if (!temp.value.canResize && !temp.value.canRotate && !temp.value.canTranslate) {
                                            controller.widgetsData[idx]['can_rotate'] = true;
                                            controller.widgetsData[idx]['can_resize'] = true;
                                            controller.widgetsData[idx]['can_translate'] = true;
                                          } else {
                                            controller.widgetsData[idx]['can_rotate'] = false;
                                            controller.widgetsData[idx]['can_resize'] = false;
                                            controller.widgetsData[idx]['can_translate'] = false;
                                          }
                                          controller.widgetsData.refresh();
                                        },
                                        child: Expanded(
                                          child: Container(
                                            child: Image.asset(
                                              !temp.value.canTranslate && !temp.value.canResize && !temp.value.canRotate
                                                  ? 'assets/icons/lock.png'
                                                  : 'assets/icons/unlock.png',
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      child: Image.asset(
                                        'assets/icons/show-preview.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //* stroke slider
                  Obx(
                    () => Visibility(
                      visible: controller.isStroke.value,
                      child: Positioned.fill(
                        bottom: 64 + 60,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            elevation: 15,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: kBgWhite,
                                border: Border(
                                  bottom: BorderSide(
                                    color: kInactiveColor,
                                  ),
                                ),
                              ),
                              child: Slider(
                                value: controller.stroke.value,
                                activeColor: kBgBlack,
                                inactiveColor: kInactiveColor.withOpacity(0.4),
                                thumbColor: kBgBlack,
                                min: 1.0,
                                max: 20.0,
                                onChanged: (value) {
                                  controller.stroke.value = value;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //* Color picker
                  Obx(
                    () => Visibility(
                      visible: controller.isColorPicker.value && controller.botNavIndex.value == 4,
                      child: Positioned.fill(
                        bottom: 64 + 60,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            elevation: 15,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: kBgWhite,
                                border: Border(
                                  bottom: BorderSide(
                                    color: kInactiveColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 20),
                                  // ColorButton(
                                  //   color: Color(controller.brushColor.value),
                                  //   onColorChanged: (value) {},
                                  // ),
                                  // EyeDropOverlay(
                                  //   colors: colors,
                                  // ),
                                  EyedropperButton(
                                    onTap: () {
                                      controller.isEyeDrop.value = true;
                                      logKey('eye drop pressed', controller.isEyeDrop.value);
                                    },
                                    onColor: (color) {
                                      logKey('EyedropperButton', color.value);
                                      controller.brushColor.value = color.value;
                                      controller.isEyeDrop.value = false;
                                    },
                                    child: Image.asset(
                                      'assets/icons/eyedropper.png',
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     logKey('history', controller.history);
                                  //   },
                                  //   child: Container(
                                  //     height: 38,
                                  //     width: 38,
                                  //     child: Image.asset(
                                  //       'assets/icons/eyedropper.png',
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      controller.showColorPicker();
                                    },
                                    child: Container(
                                      height: 38,
                                      width: 38,
                                      child: Image.asset(
                                        'assets/icons/color-wheel.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: 38,
                                      child: ListView.separated(
                                        padding: EdgeInsets.only(left: 8, right: 8),
                                        shrinkWrap: true,
                                        itemCount: controller.colorsList.length,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 5);
                                        },
                                        itemBuilder: (context, index) {
                                          return ColorItem(
                                            color: controller.colorsList[index],
                                            onTap: () {
                                              controller.brushColor.value = controller.colorsList[index].value;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //* Brush items
                  Obx(
                    () => Visibility(
                      visible: controller.botNavIndex.value == 4,
                      child: Positioned.fill(
                        bottom: 64,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Material(
                            elevation: 15,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: kInactiveColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Obx(
                                    () => BrushItem(
                                      image: 'assets/icons/brush-tool.png',
                                      color: controller.isDraw.value ? kInactiveColor.withOpacity(0.4) : kBgWhite,
                                      onTap: () {
                                        controller.isDraw.value = true;
                                      },
                                    ),
                                  ),
                                  Obx(
                                    () => BrushItem(
                                      image: 'assets/icons/erase.png',
                                      color: !controller.isDraw.value ? kInactiveColor.withOpacity(0.4) : kBgWhite,
                                      onTap: () {
                                        controller.isDraw.value = false;
                                      },
                                    ),
                                  ),
                                  Obx(
                                    () => BrushItem(
                                      image: 'assets/icons/stroke.png',
                                      color: controller.isStroke.value ? kInactiveColor.withOpacity(0.4) : kBgWhite,
                                      onTap: () {
                                        controller.isColorPicker.value = false;
                                        controller.isStroke.value = !controller.isStroke.value;
                                      },
                                    ),
                                  ),
                                  Obx(
                                    () => BrushItem(
                                      color: Color(controller.brushColor.value),
                                      border: Border.all(color: kInactiveColor),
                                      onTap: () {
                                        controller.isStroke.value = false;
                                        controller.isColorPicker.value = !controller.isColorPicker.value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //* Bottom navigation
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: 64,
                      width: Get.width,
                      color: kBgWhite,
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => CanvasBotnavbarItem(
                                color: controller.botNavIndex.value == 0 ? kBgBlack : kInactiveColor,
                                asset: 'assets/icons/image.png',
                                text: 'Image',
                                onTap: () {
                                  controller.botNavTap(0);
                                  if (controller.botNavIndex.value == 0) {
                                    controller.openImage();
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: CanvasBotnavbarItem(
                              color: controller.botNavIndex.value == 1 ? kBgBlack : kInactiveColor,
                              asset: 'assets/icons/art.png',
                              text: 'Art',
                              onTap: () {
                                controller.botNavTap(1);
                                controller.testGif();
                              },
                            ),
                          ),
                          Expanded(
                            child: CanvasBotnavbarItem(
                              color: controller.botNavIndex.value == 2 ? kBgBlack : kInactiveColor,
                              asset: 'assets/icons/text.png',
                              text: 'Text',
                              onTap: () {
                                controller.botNavTap(2);
                                if (controller.botNavIndex.value == 2) {
                                  controller.addWidget(
                                    type: CanvasItemType.TEXT,
                                    // data: 'Tap to edit',
                                    data: TextWidgetDataModels(
                                      text: 'Tap to edit',
                                      fontSize: TextSizeHelper.ExtraLarge,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: CanvasBotnavbarItem(
                              color: controller.botNavIndex.value == 3 ? kBgBlack : kInactiveColor,
                              asset: 'assets/icons/background.png',
                              text: 'Background',
                              onTap: () {
                                controller.botNavTap(3);
                              },
                            ),
                          ),
                          Expanded(
                            child: CanvasBotnavbarItem(
                              color: controller.botNavIndex.value == 4 ? kBgBlack : kInactiveColor,
                              asset: 'assets/icons/brush.png',
                              text: 'Brush',
                              onTap: () {
                                controller.botNavTap(4);
                                var isBrushExist = controller.checkBrushExist();
                                logKey('isBrushExist', isBrushExist);
                                if (!isBrushExist) {
                                  controller.addWidget(
                                    type: CanvasItemType.BRUSH_BASE,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //*text editing
                  Obx(
                    () => Visibility(
                      visible: controller.isTextEditMode.value,
                      child: Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: controller.isKeybordShowed.value ? 60 : 310,
                            ),
                            color: kBgWhite,
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/font.png',
                                          isActive: controller.textEditIndex.value == 0,
                                          onTap: () {
                                            controller.changedTextEditing(0);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/font-size.png',
                                          isActive: controller.textEditIndex.value == 1,
                                          onTap: () {
                                            controller.changedTextEditing(1);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/bold.png',
                                          isActive: controller.textEditIndex.value == 2,
                                          onTap: () {
                                            controller.changedTextEditing(2);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/align-left.png',
                                          isActive: controller.textEditIndex.value == 3,
                                          onTap: () {
                                            controller.changedTextEditing(3);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/line-height.png',
                                          isActive: controller.textEditIndex.value == 4,
                                          onTap: () {
                                            controller.changedTextEditing(4);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextEditingItems(
                                          assets: 'assets/icons/color.png',
                                          isActive: controller.textEditIndex.value == 5,
                                          onTap: () {
                                            controller.changedTextEditing(5);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //* List fonts
                                Obx(
                                  () => Visibility(
                                    visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 0,
                                    child: Expanded(
                                      child: TextEditingFonts(),
                                    ),
                                  ),
                                ),

                                //* Font size
                                Obx(
                                  () {
                                    int idx = controller.getIndexActiveTextEdit();
                                    return Visibility(
                                      visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 1,
                                      child: Expanded(
                                        child: TextEditingFontSize(
                                          index: idx,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                //* Font Style
                                Obx(
                                  () {
                                    int idx = controller.getIndexActiveTextEdit();
                                    return Visibility(
                                      visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 2,
                                      child: Expanded(
                                        child: TextEditingFontStyle(idx: idx),
                                      ),
                                    );
                                  },
                                ),

                                //* Text align
                                Obx(
                                  () {
                                    int idx = controller.getIndexActiveTextEdit();
                                    return Visibility(
                                      visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 3,
                                      child: Expanded(
                                        child: TextEditingAlignment(
                                          idx: idx,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                //* Text line height
                                Obx(
                                  () {
                                    int idx = controller.getIndexActiveTextEdit();
                                    return Visibility(
                                      visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 4,
                                      child: Expanded(
                                        child: TextEditingLineHeight(
                                          index: idx,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                //* Text color
                                Obx(
                                  () {
                                    int idx = controller.getIndexActiveTextEdit();
                                    return Visibility(
                                      visible: !controller.isKeybordShowed.value && controller.textEditIndex.value == 5,
                                      child: Expanded(
                                        child: TextEditingColor(idx: idx),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// bottomNavigationBar: Obx(
//   () => BottomNavigationBar(
//     type: BottomNavigationBarType.fixed,
//     currentIndex: controller.selected.value,
//     selectedItemColor: kBgBlack,
//     unselectedItemColor: kInactiveColor,
//     onTap: (value) {
//       controller.selected.value = value;
//     },
//     items: [
//       BottomNavigationBarItem(
//         label: 'Image',
//         icon: ImageIcon(
//           AssetImage(
//             'assets/icons/image.png',
//           ),
//           color: controller.selected.value == 0 ? kBgBlack : kInactiveColor,
//         ),
//       ),
//       BottomNavigationBarItem(
//         label: 'Art',
//         icon: ImageIcon(
//           AssetImage(
//             'assets/icons/art.png',
//           ),
//           color: controller.selected.value == 1 ? kBgBlack : kInactiveColor,
//         ),
//       ),
//       BottomNavigationBarItem(
//         label: 'Text',
//         icon: ImageIcon(
//           AssetImage(
//             'assets/icons/text.png',
//           ),
//           color: controller.selected.value == 2 ? kBgBlack : kInactiveColor,
//         ),
//       ),
//       BottomNavigationBarItem(
//         label: 'Background',
//         icon: ImageIcon(
//           AssetImage(
//             'assets/icons/background.png',
//           ),
//           color: controller.selected.value == 3 ? kBgBlack : kInactiveColor,
//         ),
//       ),
//       BottomNavigationBarItem(
//         label: 'Brush',
//         icon: ImageIcon(
//           AssetImage(
//             'assets/icons/brush.png',
//           ),
//           color: controller.selected.value == 4 ? kBgBlack : kInactiveColor,
//         ),
//       ),
//     ],
//   ),
// ),
