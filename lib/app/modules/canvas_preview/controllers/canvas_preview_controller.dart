import 'package:get/get.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../../../models/create_post_model.dart';

class CanvasPreviewController extends GetxController {
  var canvasItems = [].obs;
  // var arg = {}.obs;

  void initialFunction() {
    if (isNotEmpty(Get.arguments)) {
      var data = CreatePostModel.fromJson(Get.arguments);
      canvasItems.addAll(data.images);
      canvasItems.addAll(data.texts);
      canvasItems.addAll(data.gifs);
      canvasItems.sort((a, b) => a.index.compareTo(b.index));
    }
  }

  @override
  void onInit() {
    super.onInit();
    initialFunction();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
