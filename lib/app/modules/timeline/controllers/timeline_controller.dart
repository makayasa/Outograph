import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:outograph/app/config/environtment.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/utils/function_utils.dart';
import 'package:outograph/app/utils/network_utils.dart';

class TimelineController extends GetxController {
  var box = GetStorage();
  var netUtil = NetworkUtil.internal();

  var testTimeline = [].obs;
  var newTimeLine = [].obs;

  void getTimeLineTest() {
    List temp = box.read('canvas') ?? [];
    testTimeline.assignAll(temp);
    logKey('testTimeline', testTimeline);
  }

  void getPost() async {
    logKey('getPost masuk');
    dio.Response res = await netUtil.get(
      '${baseUrl}/post',
    );
    logKey('res getPost', res.data);
    List temp = []..assignAll(res.data);
    //* Looping data array dari api
    for (var i = 0; i < temp.length; i++) {
      var tempList = [];
      for (Map<String, dynamic> e in temp[i]['texts']) {
        e['font']['font_size'] = e['font']['font_size'].toDouble();
        tempList.add(
          {
            'type': CanvasItemType.TEXT,
            ...e,
          },
        );
      }
      for (Map<String, dynamic> e in temp[i]['images']) {
        tempList.add(
          {
            'type': CanvasItemType.IMAGE,
            ...e,
          },
        );
      }
      tempList.sort((a, b) => a['index'].compareTo(b['index']));
      temp[i]['items'] = tempList;
    }
    // for (Map<String, dynamic> element in temp) {
    //   var tempList = [];
    //   tempList.addAll(element['texts']);
    //   tempList.addAll(element['images']);
    //   element.assign('items', tempList);
    //   logKey('element', element);
    // }
    logKey('tempz', temp);
    newTimeLine.assignAll(temp);
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
