import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/canvas_item_global.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../controllers/timeline_controller.dart';

class TimelineView extends GetView<TimelineController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TimelineView'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.separated(
          // itemCount: controller.testTimeline.length,
          itemCount: controller.newTimeLine.length,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },
          itemBuilder: (context, index) {
            // List items = controller.testTimeline[index]['canvas'];
            List items = controller.newTimeLine[index]['items'];
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 500,
                    color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1),
                    child: Stack(
                      fit: StackFit.expand,
                      children: items
                          .asMap()
                          .map((idx, value) {
                            var data = items[idx];
                            logKey('dataz', data);
                            return MapEntry(
                              idx,
                              Positioned(
                                left: data['x_axis'].toDouble(),
                                top: data['y_axis'].toDouble(),
                                child: Transform.rotate(
                                  angle: data['angle_rotation'].toDouble(),
                                  child: Transform.scale(
                                    scale: data['scale'].toDouble(),
                                    child: Container(
                                      child: CanvasItemGlobal(
                                        data: data,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  // DefText(controller.testTimeline[index]['caption']).normal,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
