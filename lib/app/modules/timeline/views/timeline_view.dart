import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/modules/timeline/components/timeline_item.dart';

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
                            // var _widgetData = CanvasItemModels.fromJson(controller.testTimeline[index]['canvas'][idx]).obs;
                            var data = items[idx];
                            return MapEntry(
                              idx,
                              Positioned(
                                left: data['x_axis'].toDouble(),
                                top: data['y_axis'].toDouble(),
                                // left: _widgetData.value.dx,
                                // top: _widgetData.value.dy,
                                child: Transform.rotate(
                                  // angle: _widgetData.value.rotation,
                                  angle: data['angle_rotation'].toDouble(),
                                  child: Transform.scale(
                                    // scale: _widgetData.value.scale,
                                    scale: data['scale'].toDouble(),
                                    child: Container(
                                      child: TimelineItem(
                                        // index: index,
                                        // indexCanvas: idx,
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
                      // children: items
                      //     .asMap()
                      //     .map((idx, value) {
                      //       var _widgetData = CanvasItemModels.fromJson(controller.testTimeline[index]['canvas'][idx]).obs;
                      //       // logKey('tes zxc', _widgetData.value.color);
                      //       return MapEntry(
                      //           idx,
                      //           Obx(
                      //             () => Positioned(
                      //               left: _widgetData.value.dx,
                      //               top: _widgetData.value.dy,
                      //               // left: 0,
                      //               // top: 0,
                      //               child: Transform.rotate(
                      //                 angle: _widgetData.value.rotation,
                      //                 child: Transform.scale(
                      //                   scale: _widgetData.value.scale,
                      //                   child: Container(
                      //                     child: TimelineItem(
                      //                       index: index,
                      //                       indexCanvas: idx,
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ));
                      //     })
                      //     .values
                      //     .toList(),
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
