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
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/canvas_widget_model.dart';
import 'package:outograph/app/models/draw_pont.dart';
import 'package:outograph/app/models/image_widget_data_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../utils/function_utils.dart';
import '../../../components/default_text.dart';
import '../../../config/constants.dart';
import '../../../models/gif_widget_data_models.dart';

class CanvasController extends GetxController {
  var box = GetStorage();
  var bait = 75.obs;

  var botNavIndex = (0 - 1).obs;
  var widgetsData = [].obs;

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
    imageScrollController.dispose();
    keyboardSubscription.cancel();
  }

  //* functions

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

  void addWidget({String type = '', dynamic data}) {
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
      widgetsData.add(
        {
          'type': type,
          'data': data,
          'imageWidgetBool': false,
          'dx': 0.0,
          'dy': 0.0,
          'scale': 1.0,
          'rotation': 0.0,
          'color': color,
          'matrix': Matrix4.identity().storage,
          'matrix_translation': Matrix4.identity().storage,
          'matrix_scale': Matrix4.identity().storage,
          'matrix_rotation': Matrix4.identity().storage,
        },
      );
      saveState(type: CanvasItemType.BRUSH);
      return;
    }
    if (type == CanvasItemType.IMAGE) {
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
      logKey('masuk tipe gif');
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
      saveState();
      return;
    }
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
    // saveState();
  }

  bool checkEditMode() {
    var isEditModeExist = false;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['edit_mode']) {
        isEditModeExist = true;
        break;
      }
    }
    return isEditModeExist;
  }

  int getIndexActiveEditMode() {
    int index = -1;
    for (var i = 0; i < widgetsData.length; i++) {
      if (widgetsData[i]['edit_mode']) {
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
      logKey('brush saveState', drawPoint.length);
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
    logKey('prevState', prevStateData);
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
    // logKey('undo check edit mode', checkEditMode());
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
    widgetsData.assignAll(tempStateData['state']);
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
