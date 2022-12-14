import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var box = GetStorage();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Get.toNamed(Routes.CANVAS);
  }

  @override
  void onClose() {}

  void deleteTimeline() {
    box.remove('canvas');
  }
}
