import 'package:get/get.dart';

import '../controllers/canvas_preview_controller.dart';

class CanvasPreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CanvasPreviewController>(
      () => CanvasPreviewController(),
    );
  }
}
