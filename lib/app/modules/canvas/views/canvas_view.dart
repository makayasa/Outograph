import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/config/constants.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/snap_res_model.dart';
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

import '../../../helpers/text_size_helper.dart';
import '../../../models/canvas_widget_model.dart';
import '../../../models/text_widget_data_models.dart';
import '../../../utils/function_utils.dart';
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
              Get.back();
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
            Row(
              children: [
                Obx(
                  () => Visibility(
                    visible: controller.widgetsData.isNotEmpty,
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          // controller.testPublish();
                          // Get.toNamed(Routes.CANVAS_PREVIEW);
                          controller.testPost();
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
                                DefText('Publish').normal,
                                // DefText('Bytes : ${controller.bytes.value}').normal,
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
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isTextEditMode.value || controller.objectEditMode.value,
                    child: SizedBox(width: 10),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: controller.isTextEditMode.value || controller.objectEditMode.value,
                    child: Material(
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
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
          ],
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: GetX<CanvasController>(
            init: CanvasController(),
            builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        //* Canvas base
                        Positioned.fill(
                          child: Stack(
                            children: [
                              Container(
                                key: controller.canvasKey,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: controller.widgetsData
                                      .asMap()
                                      .map(
                                        (idx, value) {
                                          var index = idx;
                                          var baseScaleFactor = 1.0;
                                          var baseRotationFactor = 0.0;

                                          // var _offset = Offset.zero;
                                          var _initialFocalPoint = Offset.zero;
                                          var _sessionOffet = Offset.zero;
                                          bool snapTrigger = false;
                                          return MapEntry(
                                            index,
                                            Obx(
                                              () {
                                                var _widgetData = CanvasItemModels.fromJson(controller.widgetsData[index]).obs;
                                                return Positioned(
                                                  left: _widgetData.value.dx,
                                                  top: _widgetData.value.dy,
                                                  child: Transform.rotate(
                                                    angle: _widgetData.value.rotation,
                                                    child: Transform.scale(
                                                      scale: _widgetData.value.scale,
                                                      child: GestureDetector(
                                                        onTap: () {
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
                                                          controller.widgetsData.refresh();
                                                        },
                                                        onScaleStart: (details) {
                                                          baseScaleFactor = _widgetData.value.scale;
                                                          baseRotationFactor = _widgetData.value.rotation;
                                                          _initialFocalPoint = details.focalPoint;
                                                        },
                                                        onScaleUpdate: (details) {
                                                          _sessionOffet = details.focalPoint - _initialFocalPoint;
                                                          if (!controller.shouldSnap.value) {
                                                            controller.widgetsData[index]['dx'] = _sessionOffet.dx + _widgetData.value.configDx;
                                                            controller.widgetsData[index]['dy'] = _sessionOffet.dy + _widgetData.value.configDy;
                                                            if (_widgetData.value.canResize) {
                                                              controller.widgetsData[index]['scale'] = baseScaleFactor * details.scale;
                                                            }
                                                            if (_widgetData.value.canRotate) {
                                                              controller.widgetsData[index]['rotation'] = baseRotationFactor + details.rotation;
                                                            }
                                                            _widgetData.refresh();
                                                            return;
                                                          }

                                                          //* if should snap
                                                          controller.calcEdge(index);
                                                          var edge = controller.checkEdge(index);
                                                          var res = SnapResModel.fromJson(edge);
                                                          if (!res.trigger) {
                                                            controller.widgetsData[index]['dx'] = _sessionOffet.dx + _widgetData.value.configDx;
                                                            controller.widgetsData[index]['dy'] = _sessionOffet.dy + _widgetData.value.configDy;
                                                            if (_widgetData.value.canResize) {
                                                              controller.widgetsData[index]['scale'] = baseScaleFactor * details.scale;
                                                            }
                                                            if (_widgetData.value.canRotate) {
                                                              controller.widgetsData[index]['rotation'] = baseRotationFactor + details.rotation;
                                                            }
                                                          } else {
                                                            if (res.isLeft || res.isRight) {
                                                              if (_sessionOffet.dx > 15 || _sessionOffet.dx <= -15) {
                                                                controller.widgetsData[index]['dx'] = _sessionOffet.dx + _widgetData.value.configDx;
                                                              }
                                                              controller.widgetsData[index]['dy'] = _sessionOffet.dy + _widgetData.value.configDy;
                                                            } else if (res.isTop || res.isBottom) {
                                                              if (_sessionOffet.dy > 15 || _sessionOffet.dy <= -15) {
                                                                controller.widgetsData[index]['dy'] = _sessionOffet.dy + _widgetData.value.configDy;
                                                              }
                                                              controller.widgetsData[index]['dx'] = _sessionOffet.dx + _widgetData.value.configDx;
                                                            }
                                                          }

                                                          _widgetData.refresh();
                                                        },
                                                        onScaleEnd: (details) {
                                                          // _offset += _sessionOffet;
                                                          logKey('snapTrigger', snapTrigger);
                                                          if (!snapTrigger) {
                                                            controller.widgetsData[index]['configDx'] += _sessionOffet.dx;
                                                            controller.widgetsData[index]['configDy'] += _sessionOffet.dy;
                                                            _sessionOffet = Offset.zero;
                                                            _widgetData.refresh();
                                                            controller.saveState();
                                                            // logKey('data scaleEnd', controller.widgetsData[index]['left_edge']);
                                                          }
                                                        },
                                                        child: Container(
                                                          child: CanvasItem(index: index),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      )
                                      .values
                                      .toList(),
                                ),
                              ),
                              Obx(
                                () => Container(
                                  height: controller.topHeight.value,
                                  color: Colors.white.withOpacity(0.65),
                                ),
                              ),
                              Obx(
                                () => Positioned(
                                  right: 50,
                                  top: controller.topHeight.value - 19,
                                  child: GestureDetector(
                                    onPanEnd: (details) {
                                      controller.topHeightEnd.value = controller.topHeight.value;
                                    },
                                    onPanUpdate: (details) {
                                      var height = controller.topHeightEnd.value + details.localPosition.dy;
                                      var temp = controller.canvasHeight.value - controller.bottomHeight.value - height;
                                      if (height <= 0) {
                                        return;
                                      }
                                      if (temp <= controller.minimumHeight) {
                                        return;
                                      }

                                      controller.topHeight.value = height;
                                      controller.calcCanvasSize();
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.amber,
                                      ),
                                      child: Icon(
                                        Icons.arrow_downward,
                                        // size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(
                                  () => Container(
                                    height: controller.bottomHeight.value,
                                    color: Colors.white.withOpacity(0.65),
                                  ),
                                ),
                              ),
                              //* Bottom slide height
                              Positioned(
                                bottom: controller.bottomHeight.value - 19,
                                right: 50,
                                child: GestureDetector(
                                  onPanEnd: (details) {
                                    controller.bottomHeightEnd.value = controller.bottomHeight.value;
                                  },
                                  onPanUpdate: (details) {
                                    var height = controller.bottomHeightEnd.value - details.localPosition.dy;
                                    var temp = controller.canvasHeight.value - controller.topHeight.value - height;
                                    if (height <= 0) {
                                      return;
                                    }
                                    if (temp <= controller.minimumHeight) {
                                      return;
                                    }
                                    controller.bottomHeight.value = height;
                                    controller.calcCanvasSize();
                                  },
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber,
                                    ),
                                    child: Icon(
                                      Icons.arrow_upward,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              // bottom: 64,
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  // controller.widgetsData[idx]['can_rotate'] = !controller.widgetsData[idx]['can_rotate'];
                                                  // controller.widgetsData.refresh();
                                                  controller.rotation45Degree();
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                    'assets/icons/rotate-object.png',
                                                    color: !canRorate ? kInactiveColor : kBgBlack,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.resetRotation();
                                            },
                                            child: Container(
                                              child: Image.asset(
                                                'assets/icons/reset-rotate.png',
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
                                          () => Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                controller.shouldSnap.value = !controller.shouldSnap.value;
                                              },
                                              child: Container(
                                                child: Image.asset(
                                                  'assets/icons/magnet.png',
                                                  color: !controller.shouldSnap.value ? kInactiveColor : kBgBlack,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.cropImage();
                                            },
                                            child: Container(
                                              child: Image.asset(
                                                'assets/icons/crop.png',
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
                                            var temp = CanvasItemModels.fromJson(controller.widgetsData[idx]).obs;
                                            return Expanded(
                                              child: GestureDetector(
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
                                          child: GestureDetector(
                                            onTap: () {
                                              // logKey('widgetData', controller.widgetsData);
                                              // controller.testSameMatrix();
                                              controller.moveTo(top: true);
                                              // controller.getSize();
                                            },
                                            child: Container(
                                              child: Image.asset(
                                                'assets/icons/show-preview.png',
                                              ),
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
                              bottom: 60,
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
                              bottom: 60,
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
                              // bottom: 64,
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
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    height: 64,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: kBgWhite,
                        border: Border(
                          top: BorderSide(
                            color: kBgBlack,
                          ),
                        )),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => CanvasBotnavbarItem(
                              color: controller.botNavIndex.value == 0 ? kBgBlack : kInactiveColor,
                              asset: 'assets/icons/image.png',
                              text: 'Image',
                              onTap: () {
                                if (controller.objectEditMode.value) {
                                  return;
                                }
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
                              if (controller.objectEditMode.value) {
                                return;
                              }
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
                              if (controller.objectEditMode.value) {
                                return;
                              }
                              controller.botNavTap(2);
                              if (controller.botNavIndex.value == 2) {
                                controller.addWidget(
                                  type: CanvasItemType.TEXT,
                                  // data: 'Tap to edit',
                                  data: TextWidgetDataModelsOld(
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
                              if (controller.objectEditMode.value) {
                                return;
                              }
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
                              if (controller.objectEditMode.value) {
                                return;
                              }
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

  // Positioned.fill(
                  //   child: Container(
                  //     child: Stack(
                  //       fit: StackFit.expand,
                  //       children: controller.widgetsData
                  //           .asMap()
                  //           .map(
                  //             (idx, value) {
                  //               var index = idx;
                  //               var widget = CanvasItemModels.fromJson(controller.widgetsData[index]);
                  //               var _scale = 1.0.obs;
                  //               var _angle = 0.0.obs;
                  //               var _angelDelta = 0.0.obs;
                  //               var _oldAngel = 0.0.obs;

                  //               var ddx = 0.0.obs;
                  //               var ddy = 0.0.obs;

                  //               var baseScaleFactor = 1.0;

                  //               _angle.value = widget.rotation;
                  //               if (widget.scale != 0) {
                  //                 _scale.value = widget.scale;
                  //               }

                  //               if (widget.dx != 0) {
                  //                 ddx.value = widget.dx;
                  //               }
                  //               if (widget.dy != 0) {
                  //                 ddy.value = widget.dy;
                  //               }
                  //               if (controller.widgetsData[0]['type'] == CanvasItemType.BACKGROUND) {
                  //                 index += 1;
                  //               }

                  //               Matrix4 _tempMatrix = Matrix4.identity();
                  //               Matrix4 _tempTM = Matrix4.identity();
                  //               Matrix4 _tempSM = Matrix4.identity();
                  //               Matrix4 _tempRM = Matrix4.identity();

                  //               return MapEntry(
                  //                 index,
                  //                 Obx(
                  //                   () {
                  //                     return Positioned(
                  //                       top: ddy.value,
                  //                       left: ddx.value,
                  //                       child: Transform.rotate(
                  //                         angle: _angle.value,
                  //                         alignment: FractionalOffset.center,
                  //                         // angle: pi / 12,
                  //                         child: Transform.scale(
                  //                           scale: _scale.value,
                  //                           child: Container(
                  //                             color: Colors.amber,
                  //                             child: LayoutBuilder(
                  //                               builder: (context, constraints) {
                  //                                 Offset centerOfGestureDetector = Offset(constraints.maxWidth / 2, 130);
                  //                                 logKey('centerOfGestureDetector', centerOfGestureDetector);
                  //                                 return Stack(
                  //                                   clipBehavior: Clip.none,
                  //                                   children: [
                  //                                     OverlayWidget(
                  //                                       index: index,
                  //                                       onTap: () {
                  //                                         bool isEditMode = controller.checkEditMode();
                  //                                         if (!isEditMode) {
                  //                                           //* if text widget
                  //                                           if (controller.widgetsData[index]['type'] == CanvasItemType.TEXT) {
                  //                                             if (controller.checkTextEditActive()) {
                  //                                               Get.snackbar('Alert', 'Please save your current text');
                  //                                               return;
                  //                                             }
                  //                                             if (!controller.widgetsData[index]['edit_mode']) {
                  //                                               controller.widgetsData[index]['edit_mode'] = true;
                  //                                               controller.isTextEditMode.value = !controller.isTextEditMode.value;
                  //                                               controller.widgetsData.refresh();
                  //                                             }
                  //                                             return;
                  //                                           }

                  //                                           controller.objectEditMode.value = true;
                  //                                           controller.widgetsData[index]['edit_mode'] = !controller.widgetsData[index]['edit_mode'];
                  //                                         }
                  //                                         controller.widgetsData.refresh();
                  //                                       },
                  //                                       // shouldRotate: controller.widgetsData[index]['can_rotate'] ?? false,
                  //                                       shouldRotate: true,
                  //                                       shouldScale: controller.widgetsData[index]['can_resize'] ?? false,
                  //                                       shouldTranslate: controller.widgetsData[index]['can_translate'] ?? true,
                  //                                       newCallback: (dx, dy, scale, rotation) {
                  //                                         ddx.value = dx;
                  //                                         ddy.value = dy;
                  //                                         logKey('scale newCallback,', scale);
                  //                                       },
                  //                                       callBack: (m) {
                  //                                         logKey('callback', m);
                  //                                         var zxc = MxGestureDetector.decomposeToValues(_tempMatrix);
                  //                                         _angle.value = zxc.rotation;
                  //                                         _scale.value = zxc.scale;
                  //                                       },
                  //                                       onScaleEnd: (details) {
                  //                                         var decompose = MxGestureDetector.decomposeToValues(_tempMatrix);
                  //                                         if (controller.redoStates.isNotEmpty) {
                  //                                           controller.redoStates.clear();
                  //                                         }
                  //                                         //* for detect is it on the undo state. Needed to control the matrix widget
                  //                                         var _undoState = controller.widgetsData[index]['imageWidgetBool'];
                  //                                         controller.widgetsData[index]['dx'] = decompose.translation.dx;
                  //                                         controller.widgetsData[index]['dy'] = decompose.translation.dy;
                  //                                         controller.widgetsData[index]['scale'] = decompose.scale;
                  //                                         controller.widgetsData[index]['rotation'] = decompose.rotation;
                  //                                         controller.widgetsData[index]['matrix'] = _tempMatrix.storage;
                  //                                         controller.widgetsData[index]['matrix_translation'] = _tempTM.storage;
                  //                                         controller.widgetsData[index]['matrix_scale'] = _tempSM.storage;
                  //                                         controller.widgetsData[index]['matrix_rotation'] = _tempRM.storage;
                  //                                         controller.widgetsData[index]['imageWidgetBool'] = details['bool'];

                  //                                         // logKey('rotation', decompose.rotation);
                  //                                         logKey('ddx', decompose.translation.dx);
                  //                                         logKey('ddy', decompose.translation.dy);

                  //                                         var _size = controller.getSize(index);
                  //                                         controller.widgetsData[index]['height'] = _size['height'];
                  //                                         controller.widgetsData[index]['width'] = _size['width'];
                  //                                         controller.widgetsData[index]['top_edge'] = decompose.translation.dy - (_size['height'] / 2);
                  //                                         controller.widgetsData[index]['bottom_edge'] = decompose.translation.dy + (_size['height'] / 2);
                  //                                         controller.widgetsData[index]['right_edge'] = decompose.translation.dy + (_size['width'] / 2);
                  //                                         controller.widgetsData[index]['right_edge'] = decompose.translation.dy - (_size['width'] / 2);
                  //                                         if (_undoState) {
                  //                                           controller.widgetsData.refresh();
                  //                                         }
                  //                                         controller.saveState();
                  //                                       },
                  //                                       child: Align(
                  //                                         // alignment: Alignment.center,
                  //                                         // widthFactor: 1,
                  //                                         // heightFactor: 1,
                  //                                         child: Container(
                  //                                           height: controller.widgetsData[index]['type'] == CanvasItemType.BRUSH_BASE ? Get.height + 65 : null,
                  //                                           width: controller.widgetsData[index]['type'] == CanvasItemType.BRUSH_BASE ? Get.width + 80 : null,
                  //                                           child: CanvasItem(index: index),
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Positioned(
                  //                                       top: -10,
                  //                                       right: -10,
                  //                                       child: Transform.scale(
                  //                                         scale: 1.0 / _scale.value,
                  //                                         child: GestureDetector(
                  //                                           onTap: () {
                  //                                             logKey('tombol merah');
                  //                                           },
                  //                                           onPanStart: (details) {
                  //                                             var touchPositionFromCenter = details.localPosition - centerOfGestureDetector;
                  //                                             _angelDelta.value = _oldAngel.value - touchPositionFromCenter.direction;
                  //                                           },
                  //                                           onPanEnd: (details) {
                  //                                             _oldAngel.value = _angle.value;
                  //                                           },
                  //                                           onPanUpdate: (details) {},
                  //                                           child: Container(
                  //                                             height: 40,
                  //                                             width: 40,
                  //                                             color: Colors.red,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                   ],
                  //                                 );
                  //                               },
                  //                             ),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               );
                  //             },
                  //           )
                  //           .values
                  //           .toList(),
                  //     ),
                  //   ),
                  // ),

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
