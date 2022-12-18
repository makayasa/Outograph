import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outograph/app/config/environtment.dart';
import 'package:outograph/app/utils/function_utils.dart';
import 'package:outograph/app/utils/network_utils.dart';

class TimelineController extends GetxController {
  var box = GetStorage();
  var netUtil = NetworkUtil.internal();

  var testTimeline = [].obs;

  void getTimeLineTest() {
    List temp = box.read('canvas') ?? [];
    testTimeline.assignAll(temp);
    logKey('testTimeline', testTimeline);
  }

  void getPost() async {
    logKey('getPost masuk');
    dio.Response res = await netUtil.get(
      '${baseUrl!}/post',
    );
    logKey('res getPost', res.data);
    List temp = []..assignAll(res.data);
    for (Map<String, dynamic> element in temp) {
      var tempList = [];
      for (var e in element['images']) {
        logKey('asdasd', e['url']);
      }
    }
  }

  void initialFunctions() {
    // getTimeLineTest();
    getPost();
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
    // getTimeLineTest();
    initialFunctions();
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
