import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:outograph/app/helpers/canvas_helper.dart';
import 'package:outograph/app/models/image_widget_data_models.dart';
import 'package:outograph/app/modules/timeline/controllers/timeline_controller.dart';

import '../../../components/default_placeholder.dart';
import '../../../components/my_custom_painter.dart';
import '../../../models/gif_widget_data_models.dart';

class TimelineItem extends GetView<TimelineController> {
  const TimelineItem({
    super.key,
    required this.index,
    required this.indexCanvas,
  });
  final int index;
  final int indexCanvas;

  @override
  Widget build(BuildContext context) {
    if (controller.testTimeline[index]['canvas'][indexCanvas]['type'] == CanvasItemType.IMAGE) {
      var data = ImageWidgetDataModels.fromJson(controller.testTimeline[index]['canvas'][indexCanvas]['data']);
      File imageFile = File.fromUri(Uri.parse(data.path));
      return Container(
        constraints: BoxConstraints(maxHeight: 400),
        child: Image.file(imageFile),
      );
    }
    // Opaque targets can be hit by hit tests, causing them to both receive events within their bounds and prevent targets visually behind them from also receiving events.
    // Translucent targets both receive events within their bounds and permit targets visually behind them to also receive events.
    if (controller.testTimeline[index]['canvas'][indexCanvas]['type'] == CanvasItemType.GIF) {
      var data = GifWidgetDataModels.fromJson(controller.testTimeline[index]['canvas'][indexCanvas]['data']);
      return Container(
        child: CachedNetworkImage(
          // imageUrl: controller.widgetsData[index]['data']['url'],
          imageUrl: data.url,
          httpHeaders: {'accept': 'image/*'},
          placeholder: (context, url) {
            return DefaultPlaceholder(
              height: 70,
              width: 70,
            );
          },
        ),
      );
    }
    if (controller.testTimeline[index]['canvas'][indexCanvas]['type'] == CanvasItemType.BRUSH_BASE) {
      return Container(
        child: CustomPaint(
          painter: MyCustomPainter(
            drawPoints: controller.testTimeline[index]['canvas'][indexCanvas]['data']['drawpoint'],
          ),
        ),
      );
    }
    return Container();
  }
}
