import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outograph/app/components/default_placeholder.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/image_model/image_widget_model.dart';
import 'package:outograph/app/models/text_model/text_widget_models.dart';
import 'package:outograph/app/utils/function_utils.dart';

class CanvasItemGlobal extends StatelessWidget {
  const CanvasItemGlobal({
    super.key,
    required this.data,
    this.isLocal = false,
    // required this.index,
    // required this.indexCanvas,
  });
  final Map<String, dynamic> data;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    if (data['type'].toUpperCase() == CanvasItemType.IMAGE) {
      var temp = ImageWidgetModel.fromJson(data);
      logKey('url', temp.url);
      if (isLocal) {
        File imageFile = File.fromUri(Uri.parse(temp.url));
        return Container(
          constraints: BoxConstraints(
            maxHeight: 400,
            maxWidth: Get.width - 100,
            // minHeight: 400,
            // minWidth: Get.width - 100,
          ),
          child: Image.file(
            imageFile,
          ),
        );
      } else {
        return Container(
          constraints: BoxConstraints(maxHeight: 400),
          child: CachedNetworkImage(
            imageUrl: temp.url,
            placeholder: (context, url) => DefaultPlaceholder(
              height: 100,
              width: 100,
            ),
          ),
        );
      }
    }

    if (data['type'] == CanvasItemType.TEXT) {
      var dataText = TextWidgetModels.fromJson(data);
      try {
        var textStyle = GoogleFonts.getFont(
          dataText.font.fontFamily,
          // fontWeight: dataText.font.fontWeight,
          height: dataText.font.lineHeight,
          fontSize: dataText.font.fontSize,
        );
        return Container(
          // color: Colors.amber,
          child: Text(
            dataText.longText,
            style: textStyle,
          ),
        );
      } catch (e) {
        showToast('error font not found');
      }
    }

    // Opaque targets can be hit by hit tests, causing them to both receive events within their bounds and prevent targets visually behind them from also receiving events.
    // Translucent targets both receive events within their bounds and permit targets visually behind them to also receive events.
    // if (controller.testTimeline[index]['canvas'][indexCanvas]['type'] == CanvasItemType.GIF) {
    //   var data = GifWidgetDataModels.fromJson(controller.testTimeline[index]['canvas'][indexCanvas]['data']);
    //   return Container(
    //     child: CachedNetworkImage(
    //       // imageUrl: controller.widgetsData[index]['data']['url'],
    //       imageUrl: data.url,
    //       httpHeaders: {'accept': 'image/*'},
    //       placeholder: (context, url) {
    //         return DefaultPlaceholder(
    //           height: 70,
    //           width: 70,
    //         );
    //       },
    //     ),
    //   );
    // }

    // if (controller.testTimeline[index]['canvas'][indexCanvas]['type'] == CanvasItemType.BRUSH_BASE) {
    //   return Container(
    //     child: CustomPaint(
    //       painter: MyCustomPainter(
    //         drawPoints: controller.testTimeline[index]['canvas'][indexCanvas]['data']['drawpoint'],
    //       ),
    //     ),
    //   );
    // }
    return Container();
  }
}
