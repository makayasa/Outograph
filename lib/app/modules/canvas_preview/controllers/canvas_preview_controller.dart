import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minio/minio.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/config/environtment.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/image_model/image_widget_model.dart';
import 'package:outograph/app/utils/function_utils.dart';
import 'package:outograph/app/utils/network_utils.dart';
import 'package:path/path.dart' as pathDart;
import 'package:uuid/uuid.dart';

import '../../../models/brush_model/brush_widget_model.dart';
import '../../../models/create_post_model.dart';

class CanvasPreviewController extends GetxController with GetSingleTickerProviderStateMixin {
  GlobalKey profileKey = GlobalKey();
  ScrollController sc = ScrollController();
  NetworkUtil networkUtil = NetworkUtil.internal();
  // PageController dialogPageController = PageController();
  var isLoading = false.obs;
  var canvasHeight = 0.0.obs;
  var canvasTop = 0.0.obs;
  var canvasBottom = 0.0.obs;

  var isInPosition = false.obs;
  var isAnimated = false.obs;
  var isVisible = false.obs;
  var duration = Duration(milliseconds: 500);
  var selectedIndex = (0 - 1).obs;

  var canvasItems = [].obs;
  var canPopupImages = [].obs;

  var animatedY = 0.0.obs;
  var animatedX = 0.0.obs;
  var initialY = 0.0.obs;
  var profileHeight = 0.0.obs;
  var zoomHeight = 100.0.obs;
  var zoomWidth = 100.0.obs;
  var testScale = 1.0.obs;

  var url = ''.obs;
  var tappedIndex = 0.obs;

  late Animation<double> asd;
  late AnimationController ac;

  void initialFunction() {
    ac = AnimationController(
      vsync: this,
      duration: duration,
      value: 0.2,
    );
    asd = CurvedAnimation(
      parent: ac,
      curve: Curves.easeInOutCirc,
    );
    if (isNotEmpty(Get.arguments)) {
      var data = CreatePostModel.fromJson(Get.arguments);
      canvasHeight.value = data.height;
      canvasTop.value = data.topHeight;
      canvasBottom.value = data.bottomHeight;
      canvasItems.addAll(data.images);
      canvasItems.addAll(data.texts);
      canvasItems.addAll(data.gifs);
      if (isNotEmpty(data.brush)) {
        canvasItems.add(BrushWidgetModel.fromJson(data.brush));
      }
      canvasItems.sort((a, b) => a.index.compareTo(b.index));
      for (var e in canvasItems) {
        if (e.type == CanvasItemType.IMAGE) {
          canPopupImages.add(e);
        }
        logKey('canPopImage', canPopupImages);
      }
    }
  }

  void getInitialPosition(int i) {
    testScale.value = 0.9;
    // var actualHeight = canvasItems[i].height;
    var actualHeight = canvasItems[i].height;
    var actualWidth = canvasItems[i].width;
    animatedY.value = profileHeight.value + canvasItems[i].top_edge - sc.offset - canvasTop.value;
    animatedX.value = canvasItems[i].left_edge;
    zoomHeight.value = actualHeight;
    zoomWidth.value = actualWidth;
    // testScale.value = 1.6;
  }

  // void onTep({required int index}) async {
  //   url.value = canvasItems[index].url;
  //   getInitialPosition(index);
  // }

  int? checkIndex({required int canvasItemsIndex}) {
    var data = ImageWidgetModel.fromJson(canvasItems[canvasItemsIndex].toJson());
    for (var i = 0; i < canPopupImages.length; i++) {
      var temp = ImageWidgetModel.fromJson(canPopupImages[i].toJson());
      if (temp.path == data.path) {
        logKey('indexnya adalah', i);
        return i;
      }
    }
  }

  void onTep({required int index}) async {
    tappedIndex.value = index;
    url.value = canvasItems[index].path;
    isInPosition.value = false;
    isAnimated.value = true;
    getInitialPosition(index);
    await Future.delayed(duration);
    animatedY.value = 0.0;
    animatedX.value = 0.0;
    zoomHeight.value = Get.height;
    zoomWidth.value = Get.width;
    // checkIndex(canvasItemsIndex: index);
    // dialogPageController.jumpTo(1);
  }

  void zoomIn() {
    animatedY.value = 0.0;
  }

  @override
  void onInit() {
    super.onInit();
    initialFunction();
  }

  @override
  void onReady() {
    super.onReady();
    var size = getSizeByKey(profileKey);
    profileHeight.value = size['height'];
    animatedY.value = profileHeight.value;
  }

  @override
  void onClose() {
    // dialogPageController.dispose();
  }

  var percentage = 0.0.obs;

  void createPost() async {
    var data = CreatePostModel.fromJson(Get.arguments);
    var minio = Minio(
      endPoint: 's3.amazonaws.com',
      accessKey: awsAccessKeyId!,
      secretKey: awsSecretAccessKey!,
      region: awsRegion!,
    );
    Get.dialog(
      Obx(
        () => Dialog(
          child: Container(
            child: DefText('${percentage.value}').normal,
          ),
        ),
      ),
    );

    var _tempKeys = [];
    for (var e in data.images) {
      var uuid = Uuid().v4();
      var img = e;
      File _file = File(img.path);
      var fileName = pathDart.basename(_file.path);
      var fileExtension = fileName.split('.').last;
      var bytes = _file.readAsBytesSync();
      var s = Stream.value(bytes);
      var res = await minio.putObject(
        '$s3Bucket',
        '$tmpFolder/$uuid.$fileExtension',
        s,
        onProgress: (currByte) {
          var _percentage = currByte / bytes.length * 100;
          percentage.value = _percentage;
          logKey('percentage', _percentage);
        },
      );
      // var key = '$tmpFolder/$res.$fileExtension';
      var key = '$res.$fileExtension';
      e.key = key;
      _tempKeys.add(key);
      percentage.value = 0.0;
    }

    //* aws3_bucket works
    // try {
    //   var credential = IAMCrediental();
    //   credential.secretKey = awsAccessKeyId!;
    //   credential.secretId = awsSecretAccessKey!;
    //   var imageData = ImageData(
    //     fileName,
    //     _file.path,
    //   );
    //   var res = await Aws3Bucket.upload(
    //     '${s3Bucket!}/${tmpFolder!}',
    //     awsRegion!,
    //     awsRegion!,
    //     imageData,
    //     credential,
    //   );
    //   logKey('res', res);
    // } catch (e) {
    //   logKey('error', e.toString());
    // }

    var _data = CreatePostModel(
      width: data.width,
      height: data.height,
      topHeight: data.topHeight,
      bottomHeight: data.bottomHeight,
      gifs: data.gifs,
      images: data.images,
      texts: data.texts,
      brush: data.brush,
      hastags: data.hastags,
      peoples: data.peoples,
    );
    logKey('_data', _data.toJson());
    try {
      var res = await networkUtil.post(
        '$baseUrl/post/create-with-tmp',
        body: _data.toJson(),
      );
      logKey('res post/create-with-tmp', res);
    } catch (e) {
      logKey('post/create-with-tmp error', e.toString());
    }
    Get.back();
  }

  // void createPost() async {
  //   isLoading.value = true;
  //   Map<String, dynamic> _body = {};
  //   var data = CreatePostModel.fromJson(Get.arguments);
  //   List<ImageWidgetModel> imageEncoded = [];
  //   for (ImageWidgetModel e in data.images) {
  //     File _file = File(e.path);
  //     List<int> _imageByts = _file.readAsBytesSync();
  //     var _base64 = base64Encode(_imageByts);
  //     var temp = ImageWidgetModel(
  //       index: e.index,
  //       // url: e.url,
  //       path: '',
  //       key: _base64,
  //       width: e.width,
  //       height: e.height,
  //       createdAt: e.createdAt,
  //       // top_edge: e.top_edge,
  //       // bottom_edge: e.bottom_edge,
  //       // left_edge: e.left_edge,
  //       // right_edge: e.right_edge,
  //       default_height: e.default_height,
  //       default_width: e.default_width,
  //     );
  //     imageEncoded.add(temp);
  //   }
  //   var a = CreatePostModel(
  //     width: Get.width,
  //     height: canvasHeight.value,
  //     topHeight: canvasTop.value,
  //     bottomHeight: canvasBottom.value,
  //     gifs: [],
  //     images: imageEncoded,
  //     texts: [],
  //     brush: data.brush,
  //     hastags: [],
  //     peoples: [],
  //     caption: 'Test Caption',
  //   );
  //   logKey('a', a.toJson());
  //   // print(a.images[0].toJson());
  //   var res = await networkUtil.post(
  //     '$baseUrl/post',
  //     body: a.toJson(),
  //   );
  //   logKey('res', res);
  //   isLoading.value = false;
  // }
}
