import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:outograph/app/components/default_placeholder.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/image_model/image_widget_model.dart';
import 'package:outograph/app/models/text_model/text_widget_models.dart';

class CanvasItemGlobal extends StatelessWidget {
  const CanvasItemGlobal({
    super.key,
    required this.data,
    // required this.index,
    // required this.indexCanvas,
  });
  // final int index;
  // final int indexCanvas;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    if (data['type'].toUpperCase() == CanvasItemType.IMAGE) {
      var temp = ImageWidgetModel.fromJson(data);
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

    if (data['type'] == CanvasItemType.TEXT) {
      var temp = TextWidgetModels.fromJson(data);
      return Container(
        color: Colors.amber,
        child: Text(
          temp.longText,
        ),
      );
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
