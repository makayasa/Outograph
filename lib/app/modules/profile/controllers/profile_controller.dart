import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:outograph/app/config/environtment.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../../../helpers/canvas_helper.dart';
import '../../../utils/network_utils.dart';

class ProfileController extends GetxController {
  var netUtil = NetworkUtil.internal();

  var listPosts = [].obs;
  var listTag = [
    'Travelling world',
    'My Life',
    'Hobby',
    'Family',
    'Nature',
  ];
  var selectedTag = 0.obs;

  Future<void> getUserPost() async {
    try {
      dio.Response res = await netUtil.get('$baseUrl/post');
      logKey('getUserPost res', res.data);
      List temp = []..assignAll(res.data);
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
      listPosts.assignAll(temp);
    } catch (e) {
      logKey('getUserPost error', e.toString());
    }
  }

  void initialFunction() async {
    await getUserPost();
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
