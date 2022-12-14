import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outograph/utils/function_utils.dart';

class TimelineController extends GetxController {
  var box = GetStorage();

  var testTimeline = [].obs;

  void getTimeLine() {
    List temp = box.read('canvas') ?? [];
    testTimeline.assignAll(temp);
    logKey('testTimeline', testTimeline);
  }

  void initialFunctions() {
    getTimeLine();
  }

  void testCopy(int count) {
    for (var i = 0; i < count; i++) {
      var cpy = testTimeline[0];
      testTimeline.add(cpy);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTimeLine();
    if (testTimeline.isNotEmpty) {
      testCopy(100);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
