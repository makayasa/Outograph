import 'package:get/get.dart';
import 'package:outograph/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final count = 0.obs;
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
