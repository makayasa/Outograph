import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../../../models/brush_model/brush_widget_model.dart';
import '../../../models/create_post_model.dart';

class CanvasPreviewController extends GetxController {
  GlobalKey profileKey = GlobalKey();
  ScrollController sc = ScrollController();

  var isInPosition = false.obs;
  var isAnimated = false.obs;
  var isVisible = false.obs;
  var duration = Duration(milliseconds: 500);
  var selectedIndex = (0 - 1).obs;

  var canvasItems = [].obs;
  var animatedY = 0.0.obs;
  var animatedX = 0.0.obs;
  var initialY = 0.0.obs;
  var profileHeight = 0.0.obs;
  var zoomHeight = 100.0.obs;
  var zoomWidth = 100.0.obs;

  var url = ''.obs;

  void initialFunction() {
    if (isNotEmpty(Get.arguments)) {
      // logKey('argument', Get.arguments);
      var data = CreatePostModel.fromJson(Get.arguments);
      canvasItems.addAll(data.images);
      canvasItems.addAll(data.texts);
      canvasItems.addAll(data.gifs);
      if (isNotEmpty(data.brush)) {
        canvasItems.add(BrushWidgetModel.fromJson(data.brush));
      }
      canvasItems.sort((a, b) => a.index.compareTo(b.index));
    }
  }

  void getInitialPosition(int i) {
    var actualHeight = canvasItems[i].height;
    var actualWidth = canvasItems[i].width;
    animatedY.value = profileHeight.value + canvasItems[i].top_edge - sc.offset;
    animatedX.value = canvasItems[i].left_edge;
    zoomHeight.value = actualHeight;
    zoomWidth.value = actualWidth;
  }

  void onTep({required int index}) async {
    url.value = canvasItems[index].url;
    isInPosition.value = false;
    isAnimated.value = true;
    getInitialPosition(index);
    await Future.delayed(duration);
    animatedY.value = 0.0;
    animatedX.value = 0.0;
    zoomHeight.value = Get.height;
    zoomWidth.value = Get.width;
  }

  void zoomIn() {
    animatedY.value = 0.0;
  }

  @override
  void onInit() {
    super.onInit();
    initialFunction();
  }

  @override
  void onReady() {
    super.onReady();
    var size = getDefaultSize(profileKey);
    profileHeight.value = size['height'];
    animatedY.value = profileHeight.value;
  }

  @override
  void onClose() {}
}
