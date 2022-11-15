import 'package:get/get.dart';

import '../controllers/canvas_controller.dart';

class CanvasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CanvasController>(
      () => CanvasController(),
    );
  }
}
