import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  var dx = 0.0.obs;
  var dy = 0.0.obs;
  var scale = 1.0.obs;
  var rotation = 0.0.obs;

  var ddx = 0.0.obs;
  var ddy = 0.0.obs;

  // Offset initial = Offset.zero;
  var initialDx = 0.0.obs;
  var initialDy = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Get.toNamed(Routes.CANVAS);
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
