import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/utils/function_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          // color: Colors.lightBlue,
          child: Stack(
            // fit: StackFit.expand,
            children: [
              Obx(
                () => Positioned(
                  top: controller.dy.value,
                  left: controller.dx.value,
                  child: GestureDetector(
                    onScaleStart: (details) {
                      controller.initialDx.value = details.focalPoint.dx;
                      controller.initialDy.value = details.focalPoint.dy;
                      // logKey('initial scale', controller.scale);
                    },
                    onScaleUpdate: (details) {
                      controller.dx.value += details.focalPointDelta.dx;
                      controller.dy.value += details.focalPointDelta.dy;
                      controller.scale.value = details.scale;
                      controller.rotation.value = details.rotation;

                      // controller.ddx.value = details.focalPoint.dx - controller.initialDx.value;
                      // controller.ddy.value = details.focalPoint.dy - controller.initialDy.value;
                      // logKey(
                      //   'scale',
                      //   details.scale,
                      // );
                      logKey('controller.dx.value', controller.dx.value);
                      logKey('controller.dy.value', controller.dy.value);
                      logKey(
                        'rotate',
                        details.rotation.abs() * (180 / pi),
                      );
                    },
                    child: Obx(
                      () => Transform.scale(
                        scale: controller.scale.value,
                        child: Container(
                          height: 100 * controller.scale.value,
                          width: 100 * controller.scale.value,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
