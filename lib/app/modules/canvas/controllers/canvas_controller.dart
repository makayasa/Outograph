import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:cyclop/cyclop.dart' as cyc;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/canvas_widget_model.dart';
import 'package:outograph/app/models/draw_pont.dart';
import 'package:outograph/app/models/image_widget_data_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:vector_math/vector_math.dart' as vm;

import '../../../components/default_text.dart';
import '../../../config/constants.dart';
import '../../../models/gif_widget_data_models.dart';
import '../../../utils/function_utils.dart';

class CanvasController extends GetxController {
  GlobalKey keyRed = GlobalKey();

  List<GlobalKey> listGlobalKey = [];

  var box = GetStorage();
  var bait = 75.obs;
  var tex = 0.0.obs;
  var tey = 0.0.obs;

  var botNavIndex = (0 - 1).obs;
  var widgetsData = [].obs;
  var shouldSnap = true.obs;

  var objectEditMode = false.obs;

  RxList<DrawPoint?> redoStateBrush = (List<DrawPoint?>.of([])).obs;

  var currentState = {}.obs;

  var undoStates = [].obs;
  var redoStates = [].obs;

  //* Brush variable
  var brushColor = 0xfff44336.obs;
  var isDraw = true.obs;
  var isStroke = false.obs;
  var isColorPicker = false.obs;
  var isEyeDrop = false.obs;
  var stroke = 1.0.obs;
  RxList<DrawPoint?> drawPoint = (List<DrawPoint?>.of([])).obs;
  var colorsList = [
    Color(0xffF5222D),
    Color(0xffFA8C16),
    Color(0xffFADB14),
    Color(0xff389E0D),
    Color(0xff13C2C2),
    Color(0xff2F54EB),
    Color(0xff722ED1),
  ].obs;
  //*

  //* Text variable
  late KeyboardVisibilityController keyboardController;
  late StreamSubscription<bool> keyboardSubscription;
  var isTextEditMode = false.obs;
  var isKeybordShowed = false.obs;
  var tempEditingText = ''.obs;
  var textEditIndex = 0.obs;

  var botNavBar = [];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    initFunction();
  }

  @override
  void onClose() {
    super.onClose();
    // imageScrollController.dispose();
    textScrolLController.dispose();
    keyboardSubscription.cancel();
  }

  //* functions

  void testPublish() async {
    List temp = box.read('canvas') ?? [];
    for (var element in widgetsData) {
      if (element['type'] == CanvasItemType.BRUSH_BASE) {
        element['data'] = {'drawpoint': drawPoint};
        break;
      }
    }
    var data = {
      'caption': 'test ${temp.length}',
      'canvas': widgetsData,
    };
    temp.add(data);
    await box.write('canvas', temp);
    if (panelImageController.isPanelOpen) {
      await closeImage();
    }
    Get.back();
  }

  void botNavTap(int index) {
    if (panelImageController.isPanelShown) {
      closeImage();
    }
    isDraw.value = true;
    isStroke.value = false;
    isColorPicker.value = false;
    isEyeDrop.value = false;

    if (index == botNavIndex.value) {
      botNavIndex.value = -1;
    } else {
      botNavIndex.value = index;
    }
  }

  checkEdge(index) {
    var trigger = false;
    var isTop = false;
    var isBottom = false;
    var isLeft = false;
    var isRight = false;
    for (var i = 0; i < widgetsData.length; i++) {
      var activeItem = CanvasItemModels.fromJson(widgetsData[index]);
      var compareItem = CanvasItemModels.fromJson(widgetsData[i]);
      if (i != index && compareItem.type != CanvasItemType.BRUSH_BASE && compareItem.type != CanvasItemType.BRUSH) {
        var size = getSize(index);
        var diffWidth = widgetsData[index]['default_width'] - size['width'];
        var diffHeight = widgetsData[index]['default_height'] - size['height'];
        //* left to left snap
        if (activeItem.leftEdge.floor() == compareItem.leftEdge.floor()) {
          widgetsData[index]['dx'] = compareItem.leftEdge - (diffWidth / 2);
          trigger = true;
          isLeft = true;
        }
        //* Right to right snap
        else if (activeItem.rightEdge.floor() == compareItem.rightEdge.floor()) {
          widgetsData[index]['dx'] = compareItem.rightEdge - (diffWidth / 2) - size['width'];
          trigger = true;
          isRight = true;
        }

        //* left to right snap
        else if (activeItem.leftEdge.floor() == compareItem.rightEdge.floor()) {
          widgetsData[index]['dx'] = compareItem.rightEdge - (diffWidth / 2);
          trigger = true;
          isRight = true;
        }

        //* Right to left snap
        else if (activeItem.rightEdge.floor() == compareItem.leftEdge.floor()) {
          widgetsData[index]['dx'] = compareItem.leftEdge - (diffWidth / 2) - size['width'];
          trigger = true;
          isLeft = true;
        }
        //* Top to top snap
        else if (activeItem.topEdge.floor() == compareItem.topEdge.floor()) {
          widgetsData[index]['dy'] = compareItem.topEdge - (diffHeight / 2);
          trigger = true;
          isTop = true;
        }
        //* Top to bottom snap
        else if (activeItem.topEdge.floor() == compareItem.bottomEdge.floor()) {
          widgetsData[index]['dy'] = compareItem.bottomEdge - (diffHeight / 2);
          trigger = true;
          isTop = true;
        }
        //* Bottom to bottom snap
        else if (activeItem.bottomEdge.floor() == compareItem.bottomEdge.floor()) {
          widgetsData[index]['dy'] = compareItem.bottomEdge - (diffHeight / 2) - size['height'];
          trigger = true;
          isBottom = true;
        }
        //* Bottom to top snap
        else if (activeItem.bottomEdge.floor() == compareItem.topEdge.floor()) {
          widgetsData[index]['dy'] = compareItem.topEdge - (diffHeight / 2) - size['height'];
        }
        if (activeItem.leftEdge == compareItem.leftEdge) {
          if (!Get.isSnackbarOpen) {
            // Get.snackbar('Snapped', 'left');
          }
        }
        if (activeItem.rightEdge == compareItem.rightEdge) {
          if (!Get.isSnackbarOpen) {
            // Get.snackbar('Snapped', 'right');
          }
        }
      }
    }
    // return trigger;
    return {
      'trigger': trigger,
      'isTop': isTop,
      'isBottom': isBottom,
      'isLeft': isLeft,
      'isRight': isRight,
    };
  }

  void calcEdge(index) {
    var size = getSize(index);

    var diffHeight = size['height'] - widgetsData[index]['default_height'];
    var diffWidth = size['width'] - widgetsData[index]['default_width'];

    widgetsData[index]['top_edge'] = widgetsData[index]['dy'] - (diffHeight / 2);
    widgetsData[index]['bottom_edge'] = widgetsData[index]['top_edge'] + size['height'];
    widgetsData[index]['left_edge'] = widgetsData[index]['dx'] - (diffWidth / 2);
    widgetsData[index]['right_edge'] = widgetsData[index]['left_edge'] + size['width'];
  }

  void addWidget({String type = '', dynamic data}) async {
    redoStates.clear();
    logKey('addWidget type', type);
    var color = (math.Random().nextDouble() * 0xFFFFFF).toInt();
    if (type == CanvasItemType.BACKGROUND) {
      widgetsData.insert(
        0,
        {
          'type': type,
          'data': data,
        },
      );
      saveState();
      return;
    }
    if (type == CanvasItemType.BRUSH_BASE) {
      var key = GlobalKey();
      listGlobalKey.add(key);
      widgetsData.add(
        CanvasItemModels(
          type: type,
          data: {},
          imageWidgetBool: false,
          editMode: false,
          canRotate: false,
          canResize: false,
          color: color,
          matrix: Matrix4.identity().storage,
          matrixTranslation: Matrix4.identity().storage,
          matrixScale: Matrix4.identity().storage,
          matrixRotaion: Matrix4.identity().storage,
        ).toJson(),
      );
      // widgetsData.add(
      //   {
      //     'type': type,
      //     'data': data,
      //     'imageWidgetBool': false,
      //     'dx': 0.0,
      //     'dy': 0.0,
      //     'scale': 1.0,
      //     'rotation': 0.0,
      //     'color': color,
      //     'matrix': Matrix4.identity().storage,
      //     'matrix_translation': Matrix4.identity().storage,
      //     'matrix_scale': Matrix4.identity().storage,
      //     'matrix_rotation': Matrix4.identity().storage,
      //   },
      // );
      saveState(type: CanvasItemType.BRUSH);
      return;
    }
    if (type == CanvasItemType.IMAGE) {
      var key = GlobalKey();
      listGlobalKey.add(key);
      widgetsData.add(
        CanvasItemModels(
          type: type,
          data: ImageWidgetDataModels(
            path: data,
          ).toJson(),
          imageWidgetBool: false,
          editMode: false,
          canRotate: false,
          canResize: false,
          color: color,
          matrix: Matrix4.identity().storage,
          matrixTranslation: Matrix4.identity().storage,
          matrixScale: Matrix4.identity().storage,
          matrixRotaion: Matrix4.identity().storage,
        ).toJson(),
      );
      await Future.delayed(Duration(milliseconds: 500));
      var index = widgetsData.length - 1;
      var defSize = getDefaultSize(key);
      var diffWidth = defSize['width'] - defSize['width'];
      var diffHeight = defSize['height'] - defSize['height'];
      widgetsData[index]['default_height'] = defSize['height'];
      widgetsData[index]['default_width'] = defSize['width'];
      widgetsData[index]['top_edge'] = widgetsData[index]['dy'] - (diffHeight / 2);
      widgetsData[index]['bottom_edge'] = widgetsData[index]['top_edge'] + defSize['height'];
      widgetsData[index]['left_edge'] = widgetsData[index]['dx'] + (diffWidth / 2);
      widgetsData[index]['right_edge'] = widgetsData[index]['left_edge'] + defSize['width'];
      widgetsData.refresh();
      saveState();
      return;
    }
    if (type == CanvasItemType.TEXT) {
      widgetsData.add(
        CanvasItemModels(
          type: type,
          data: data.toJson(),
          imageWidgetBool: false,
          editMode: false,
          canRotate: false,
          canResize: false,
          color: color,
          matrix: Matrix4.identity().storage,
          matrixTranslation: Matrix4.identity().storage,
          matrixScale: Matrix4.identity().storage,
          matrixRotaion: Matrix4.identity().storage,
        ).toJson(),
      );
      saveState();
      return;
    }
    if (type == CanvasItemType.GIF) {
      var key = GlobalKey();
      listGlobalKey.add(key);
      widgetsData.add(
        CanvasItemModels(
          type: type,
          data: data,
          imageWidgetBool: false,
          editMode: false,
          canRotate: false,
          canResize: false,
          color: color,
          matrix: Matrix4.identity().storage,
          matrixTranslation: Matrix4.identity().storage,
          matrixScale: Matrix4.identity().storage,
          matrixRotaion: Matrix4.identity().storage,
        ).toJson(),
      );
      await Future.delayed(Duration(milliseconds: 500));
      var index = widgetsData.length - 1;
      var defSize = getDefaultSize(key);
      var diffWidth = defSize['width'] - defSize['width'];
      var diffHeight = defSize['height'] - defSize['height'];
      widgetsData[index]['default_height'] = defSize['height'];
      widgetsData[index]['default_width'] = defSize['width'];
      widgetsData[index]['top_edge'] = widgetsData[index]['dy'] - (diffHeight / 2);
      widgetsData[index]['bottom_edge'] = widgetsData[index]['top_edge'] + defSize['height'];
      widgetsData[index]['left_edge'] = widgetsData[index]['dx'] + (diffWidth / 2);
      widgetsData[index]['right_edge'] = widgetsData[index]['left_edge'] + defSize['width'];
      widgetsData.refresh();
      saveState();
      return;
    }
  }

  bool checkEditMode() {
    var isEditModeExist = false;
    for (var i = 0; i < widgetsData.length; i++) {
      logKey('checkEditMode', widgetsData[i]);
      if (widgetsData[i]['type'] != CanvasItemType.BRUSH_BASE && widgetsData[i]['edit_mode']) {
        isEditModeExist = true;
        break;
      }
    }
    return isEditModeExist;
  }

  int getIndexActiveEditMode() {
    int index = -1;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['edit_mode'] ?? false) {
        index = i;
        break;
      }
    }
    return index;
  }

  void moveUpWidget() {
    int activeIndex = getIndexActiveEditMode();
    if (activeIndex > 0) {
      var temp = widgetsData[activeIndex];
      widgetsData.removeAt(activeIndex);
      widgetsData.insert(activeIndex - 1, temp);
      widgetsData.refresh();
    }
  }

  void moveDownWidget() {
    int activeIndex = getIndexActiveEditMode();
    if (activeIndex == widgetsData.length - 1) {
      return;
    }
    var temp = widgetsData[activeIndex];
    widgetsData.removeAt(activeIndex);
    widgetsData.insert(activeIndex + 1, temp);
    widgetsData.refresh();
  }

  void exitEditMode() {
    int activeIndex = getIndexActiveEditMode();
    widgetsData[activeIndex]['edit_mode'] = false;
    objectEditMode.value = false;
    widgetsData.refresh();
  }

  void moveTo({bool top = false}) {
    var idx = getIndexActiveEditMode();
    // widgetsData[idx]['dx'] = -4.246036343633492;
    // widgetsData[idx]['dy'] = 45.278549268794464;
    // widgetsData[idx]['matrix'][12] = -4.246036343633492;
    // widgetsData[idx]['matrix'][13] = 45.278549268794464;
    widgetsData[idx]['dx'] = 0.0;
    widgetsData[idx]['dy'] = 0.0;
    widgetsData[idx]['matrix'][12] = 0.0;
    widgetsData[idx]['matrix'][13] = 0.0;
    widgetsData.refresh();
  }

  void resetRotation() {
    var idx = getIndexActiveEditMode();
    var temp = CanvasItemModels.fromJson(widgetsData[idx]).obs;
    if (temp.value.rotation == 0) {
      return;
    }

    var newRotation = vm.radians(0);

    widgetsData[idx]['rotation'] = newRotation;
    widgetsData.refresh();
    saveState();
    // var zxc = Matrix4Transform.from(Matrix4.fromFloat64List(temp.value.matrix)).rotate(
    //   -temp.value.rotation,
    //   origin: Offset(
    //     Get.width / 2,
    //     Get.height / 2,
    //   ),
    // );
    // var decompose = MxGestureDetector.decomposeToValues(zxc.matrix4);
    // widgetsData[idx]['matrix'] = zxc.matrix4.storage;
    // widgetsData[idx]['dx'] = decompose.translation.dx;
    // widgetsData[idx]['dy'] = decompose.translation.dy;
    // widgetsData[idx]['scale'] = decompose.scale;
    // widgetsData[idx]['rotation'] = decompose.rotation;
    // widgetsData[idx]['matrix'] = zxc.matrix4.storage;
    // widgetsData[idx]['imageWidgetBool'] = true;
    // widgetsData.refresh();
    // saveState();
  }

  void rotation45Degree() {
    var idx = getIndexActiveEditMode();
    var temp = CanvasItemModels.fromJson(widgetsData[idx]).obs;

    var zxc = Matrix4Transform.from(Matrix4.fromFloat64List(temp.value.matrix)).rotateDegrees(
      45,
      origin: Offset(
        Get.width / 2 - 30,
        Get.height / 2,
      ),
    );
    logKey('check size', Get.size.width);

    var newRotation = vm.radians(45);

    widgetsData[idx]['rotation'] += newRotation;
    widgetsData.refresh();
    saveState();

    // var decompose = MxGestureDetector.decomposeToValues(zxc.matrix4);
    // widgetsData[idx]['matrix'] = zxc.matrix4.storage;
    // widgetsData[idx]['dx'] = decompose.translation.dx;
    // widgetsData[idx]['dy'] = decompose.translation.dy;
    // widgetsData[idx]['scale'] = decompose.scale;
    // widgetsData[idx]['rotation'] = decompose.rotation;
    // widgetsData[idx]['imageWidgetBool'] = true;
    // widgetsData.refresh();
    // saveState();
  }

  void cropImage() async {
    var idx = getIndexActiveEditMode();
    var data = ImageWidgetDataModels.fromJson(widgetsData[idx]['data']);
    var file = await ImageCropper().cropImage(
      sourcePath: data.path,
    );
    if (file != null) {
      widgetsData[idx]['data'] = ImageWidgetDataModels(path: file.path).toJson();
      widgetsData.refresh();
      saveState();
    }
    logKey('cropImage File', file!.path);
  }

  getSize(int index) {
    // var idx = getIndexActiveEditMode();
    final RenderBox a = listGlobalKey[index].currentContext!.findRenderObject()! as RenderBox;
    if (widgetsData[index]['scale'] != 0) {
      var width = a.size.width * widgetsData[index]['scale'];
      var height = a.size.height * widgetsData[index]['scale'];
      return {
        'width': width,
        'height': height,
      };
    } else {
      return {
        'width': a.size.width,
        'height': a.size.height,
      };
    }
  }

  Map getDefaultSize(GlobalKey key) {
    final RenderBox a = key.currentContext!.findRenderObject()! as RenderBox;
    return {
      "height": a.size.height,
      "width": a.size.width,
    };
  }

  void testSameMatrix() {
    for (var i = 0; i < widgetsData.length; i++) {
      if (i == 1) {
        widgetsData[i]['dx'] = 6.660810939260628 + (165.8260315421728 / 2);
        widgetsData[i]['dy'] = 98.34873449466522 + (221.10137538956377 / 2);
        widgetsData[i]['scale'] = 0.637792429008357;
        widgetsData[i]['matrix'] = [
          0.6377924290083578,
          0.0,
          0.0,
          0.0,
          0.0,
          0.6377924290083578,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          6.660810939260628 + (165.8260315421728 / 2),
          98.34873449466522 - (221.10137538956377 / 2),
          0.0,
          1.0,
        ];
        break;
      }
      widgetsData[i]['dx'] = 6.660810939260628;
      widgetsData[i]['dy'] = 98.34873449466522;
      widgetsData[i]['scale'] = 0.637792429008357;
      widgetsData[i]['matrix'] = [
        0.6377924290083578,
        0.0,
        0.0,
        0.0,
        0.0,
        0.6377924290083578,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        6.660810939260628,
        98.34873449466522,
        0.0,
        1.0,
      ];
    }
    widgetsData.refresh();
  }

  void anotherTest() {
    RenderBox? renderBox = keyRed.currentContext!.findRenderObject() as RenderBox;
    logKey('size', renderBox.size.width);
  }

  //* brush functions
  bool checkBrushExist() {
    bool isExist = false;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['type'] == CanvasItemType.BRUSH_BASE) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  RxList<Color> history = (List<Color>.of([])).obs;

  void showColorPicker({bool isTextColor = false}) async {
    // cyc.EyedropperButton();
    int tempColor = brushColor.value;
    var config = cyc.ColorPickerConfig(
      enableEyePicker: true,
      enableLibrary: false,
      enableOpacity: false,
    );

    // Get.dialog(
    //   Dialog(
    //     child: cyc.ColorPicker(
    //       config: config,
    //       selectedColor: Color(tempColor),
    //       onEyeDropper: () {
    //         logKey('onEyeDropper');
    //       },
    //       onClose: () {},
    //       onColorSelected: (value) {},
    //     ),
    //   ),
    // );

    var res = await Get.dialog(
      Dialog(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // DefText('colorPicker').normal,
              ColorPicker(
                colorHistory: history,
                pickerColor: Color(tempColor),
                onHistoryChanged: (value) => history.value = value,
                onColorChanged: (color) {
                  tempColor = color.value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {
                        Get.back(
                          result: true,
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: kDefaultBorderRadius,
                        ),
                        child: Center(
                          child: DefText('Pilih').large,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Get.back(
                          result: false,
                        );
                      },
                      child: Container(
                        height: 30,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: kDefaultBorderRadius,
                        ),
                        child: Center(
                          child: DefText('Kembali').large,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
    if (res) {
      if (isTextColor) {
        var index = getIndexActiveTextEdit();
        widgetsData[index]['data']['color'] = tempColor;
        widgetsData.refresh();
        logKey('masuk sini');
        return;
      }
      brushColor.value = tempColor;
    }
  }
  //* end brush functions

  void panUpdate(int index, double dx, double dy) {
    widgetsData[index]['dx'] = widgetsData[index]['dx'] + dx;
    widgetsData[index]['dy'] = widgetsData[index]['dy'] + dy;
    widgetsData.refresh();
  }

  void panEnd() {
    redoStates.clear();
    saveState();
  }

  void redoBrush() {
    var res = box.read('kBrushState');
    redoStateBrush.assignAll(res);
    var a = [];
    for (var i = 0; i < redoStateBrush.length; i++) {
      if (redoStateBrush[i] == null) {
        a.add(i);
      }
    }
    logKey('isi null pointer redoState', a);
    if (a.isEmpty) {
      return;
    }
    if (a.length > 2) {
      var start = a[a.length - 2];
      var last = a.last;
      var temp = redoStateBrush.getRange(start, last);
      drawPoint.addAll(temp);
      redoStateBrush.removeRange(start, last);
      return;
    }
    if (a.length == 2) {
      redoStateBrush.removeRange(a.first, a.last);
      return;
    }
    redoStateBrush.clear();
  }

  //* undo redo v2

  void saveState({String type = 'widget'}) async {
    if (type == CanvasItemType.IMAGE) {
      var _tempWidget = {
        'type': type,
        'state': widgetsData,
      };
      undoStates.add(json.encode(_tempWidget));
      return;
    }
    if (type == CanvasItemType.BRUSH_BASE) {
      var _tempBrushBase = {
        'type': type,
        'state': widgetsData,
      };
      undoStates.add(json.encode(_tempBrushBase));
      return;
    }
    if (type == CanvasItemType.BRUSH) {
      var _tempBrush = {
        'type': type,
        'state': json.decode(drawPoint.toString()),
      };
      var encode = json.encode(_tempBrush);
      undoStates.add(encode);
      return;
    }
    var _tempWidget = {
      'type': type,
      'state': widgetsData,
    };
    undoStates.add(json.encode(_tempWidget));
  }

  void undo() {
    redoStates.add(undoStates.last);
    undoStates.removeLast();
    if (undoStates.isEmpty) {
      widgetsData.clear();
      return;
    }
    Map prevStateData = json.decode(undoStates.last);
    List state = prevStateData['state'];
    if (prevStateData['type'] == CanvasItemType.BRUSH) {
      drawPoint.clear();
      if (isEmpty(state)) {
        for (var i = 0; i < widgetsData.length; i++) {
          if (widgetsData[i]['type'] == CanvasItemType.BRUSH_BASE) {
            break;
          }
        }
        return;
      }
      drawPoint.value = List<DrawPoint?>.from(
        state.map(
          (e) {
            if (e != null) {
              return DrawPoint.fromJson(e);
            } else {
              return null;
            }
          },
        ),
      );
      return;
    }
    widgetsData.assignAll(prevStateData['state']);
    var different = listGlobalKey.length - widgetsData.length;
    for (var i = 0; i < different; i++) {
      listGlobalKey.removeLast();
    }
    objectEditMode.value = checkEditMode();
  }

  void redo() {
    Map tempStateData = json.decode(redoStates.last);
    logKey('redo tempStateData', tempStateData);
    List redoState = tempStateData['state'];
    if (tempStateData['type'] == CanvasItemType.BRUSH) {
      drawPoint.clear();
      drawPoint.value = List<DrawPoint?>.from(
        redoState.map(
          (e) {
            if (e != null) {
              return DrawPoint?.fromJson(e);
            } else {
              return null;
            }
          },
        ),
      );
      redoStates.removeLast();
      saveState();
      return;
    }
    widgetsData.clear();
    var key = GlobalKey();
    listGlobalKey.add(key);
    widgetsData.assignAll(tempStateData['state']);
    if (listGlobalKey.length > widgetsData.length) {
      listGlobalKey.removeLast();
    }
    // for (var i = 0; i < different; i++) {
    //   listGlobalKey.add(key);
    // }
    redoStates.removeLast();
    objectEditMode.value = checkEditMode();
    saveState();
  }

  Future<bool> filePermission() async {
    var a = await Permission.accessMediaLocation;
    var b = await a.isGranted;
    if (await a.isDenied) {
      var newStat = await a.request();
      if (await newStat.isGranted) {
        b = true;
      }
    }
    return b;
  }

  void initFunction() async {
    keyboardController = KeyboardVisibilityController();
    keyboardSubscription = keyboardController.onChange.listen((event) {
      isKeybordShowed.value = event;
      logKey('keyboard', event);
    });
    await panelImageController.hide();
    tempMinHeigh.value = 280.0;
    getGoogleFonts();
  }

  //* Text vars
  ScrollController textScrolLController = ScrollController();
  PanelController panelTextController = PanelController();
  var listFonts = [].obs;

  ///* end textvars

//!  Image begin
  var tempMinHeigh = 0.0.obs;
  ScrollController imageScrollController = ScrollController();
  PanelController panelImageController = PanelController();
  RxList<AssetPathEntity> paths = (List<AssetPathEntity>.of([])).obs;
  RxList<AssetEntity> listImages = (List<AssetEntity>.of([])).obs;
  var isBottom = false.obs;
  var imagePageIndex = 0.obs;

  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );

  Future<void> paginationImage() async {
    var res = await paths[0].getAssetListPaged(page: imagePageIndex.value, size: 40);
    listImages.addAll(res);
    logKey('listImages length pagination', listImages.length);
  }

  void openImage() async {
    imageScrollController = ScrollController();
    tempMinHeigh.value = 280.0;

    panelImageController.show();
    imageScrollController.addListener(() async {
      if (imageScrollController.position.pixels == imageScrollController.position.maxScrollExtent) {
        imagePageIndex.value++;
        await paginationImage();
        isBottom.value = true;
      }
    });
    final List<AssetPathEntity> temp = await PhotoManager.getAssetPathList(
      onlyAll: true,
      // hasAll: true,
      type: RequestType.image,
      filterOption: _filterOptionGroup,
    );
    paths.addAll(temp);
    var imagesEntity = await paths[0].getAssetListPaged(page: imagePageIndex.value, size: 40);
    listImages.addAll(imagesEntity);
    logKey('listImages length init', listImages.length);
  }

  Future<void> closeImage() async {
    imageScrollController.dispose();
    await panelImageController.hide();
    isBottom.value = false;
    imagePageIndex.value = 0;
    listImages.clear();
    // botNavIndex.value = -1;
  }

  //* Gif functions
  void testGif() async {
    if (panelImageController.isPanelOpen) {
      await closeImage();
    }
    var res = await GiphyGet.getGif(
      context: Get.context!,
      apiKey: giphyKey,
      // randomID: 'abcd',
    );
    botNavIndex.value = -1;
    if (res != null) {
      // logKey('res.images!.original!.url', res.images!.original!.url);
      addWidget(
        type: CanvasItemType.GIF,
        // data: {'url': res.images!.original!.url},
        data: GifWidgetDataModels(url: res.images!.original!.url).toJson(),
      );
    }
  }

  //* text functions
  void getGoogleFonts() async {
    var fonts = await GoogleFonts.asMap().keys.toList();
    listFonts.assignAll(fonts);
  }

  bool checkTextEditActive() {
    var isEditModeExist = false;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['type'] == CanvasItemType.TEXT && widgetsData[i]['edit_mode']) {
        isEditModeExist = true;
        break;
      }
    }
    return isEditModeExist;
  }

  int getIndexActiveTextEdit() {
    int index = -1;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['type'] == CanvasItemType.TEXT && widgetsData[i]['edit_mode']) {
        index = i;
        break;
      }
    }
    return index;
  }

  void saveText() {
    isTextEditMode.value = !isTextEditMode.value;
    var indexActive = getIndexActiveTextEdit();
    if (tempEditingText.value == '') {
      widgetsData[indexActive]['edit_mode'] = false;
      widgetsData.refresh();
      tempEditingText.value = '';
      saveState();
      botNavIndex.value = -1;
      return;
    }
    widgetsData[indexActive]['data']['text'] = tempEditingText.value;
    widgetsData[indexActive]['edit_mode'] = false;
    widgetsData.refresh();
    tempEditingText.value = '';
    saveState();
    botNavIndex.value = -1;
  }

  void changedTextEditing(int index) {
    textEditIndex.value = index;
  }
}

//* undo redo ver 1

// void saveState({String type = 'widget'}) async {
//   logKey('saveState', widgetsData);
//   if (type == 'brush') {
//     undoStates.add('brush');
//     return;
//   }
//   undoStates.add(json.encode(widgetsData));
// }

// void undo() {
//   redoStates.add(undoStates.last);
//   undoStates.removeLast();
//   if (undoStates.isEmpty) {
//     widgetsData.clear();
//     return;
//   }
//   var temp = json.decode(undoStates.last);
//   widgetsData.assignAll(temp);
// }

// void redo() {
//   var temp = json.decode(redoStates.last);
//   widgetsData.assignAll(temp);
//   redoStates.removeLast();
//   saveState();
// }

// void undoBrush() async {
//   // test.addAll(['zzz', 'xxx', 'ccc']);
//   var undoC = Get.put(UndoController());
//   // await box.write('test', test.value);
//   var tez = box.read('test');
//   logKey('tez', tez);
//   var a = [];
//   for (var i = 0; i < drawPoint.length; i++) {
//     if (drawPoint[i] == null) {
//       a.add(i);
//     }
//   }

//   if (a.isEmpty) {
//     return;
//   }
//   if (a.length > 2) {
//     var start = a[a.length - 2];
//     var last = a.last;
//     //* buat redo
//     var temp = drawPoint.getRange(start, last);
//     undoC.redoStateBrush.addAll(temp);
//     await box.write('kBrushState', undoC.redoStateBrush);
//     Get.delete<UndoController>();
//     drawPoint.removeRange(start, last);
//     return;
//   }
//   if (a.length == 2) {
//     var temp = drawPoint.getRange(a.first, a.last);
//     // redoStateBrush.addAll(temp);
//     drawPoint.removeRange(a.first, a.last);
//     return;
//   }
//   drawPoint.clear();
// }

// void openImage() async {
//   scrollController.addListener(() {
//     if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//       logKey("I'm Listening", scrollController.position.pixels);
//       imagePageIndex.value++;
//       paginationImage(imagePageIndex.value);
//       isBottom.value = true;
//       logKey('asd');
//     }
//   });

//   final List<AssetPathEntity> temp = await PhotoManager.getAssetPathList(
//     onlyAll: true,
//     // hasAll: true,
//     type: RequestType.image,
//     filterOption: _filterOptionGroup,
//   );
//   paths.addAll(temp);
//   var imagesEntity = await paths[0].getAssetListPaged(page: imagePageIndex.value, size: 20);
//   listImages.addAll(imagesEntity);
//   logKey('listImages length init', listImages.length);
//   await Get.bottomSheet(
//     CanvasImagesList(
//       scrollController: scrollController,
//     ),
//     // isScrollControlled: true,
//   );
//   scrollController.dispose();
//   isBottom.value = false;
//   imagePageIndex.value = 0;
//   listImages.clear();
//   botNavIndex.value = -1;
// }
/** Image End **/
