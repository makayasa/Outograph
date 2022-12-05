import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/mx_gesture_detector.dart';
import 'package:outograph/utils/function_utils.dart';

import '../modules/canvas/controllers/canvas_controller.dart';

class OverlayWidget extends GetView<CanvasController> {
  const OverlayWidget({
    super.key,
    required this.index,
    required this.child,
    required this.onScaleEnd,
    required this.callBack,
    this.behavior,
    this.onTap,
    this.shouldRotate = true,
    this.shouldScale = true,
    this.shouldTranslate = false,
  });
  final int index;
  final Widget child;
  final Function(Map) onScaleEnd;
  final Function(Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) callBack;
  final bool shouldRotate;
  final bool shouldScale;
  final bool shouldTranslate;
  final Function()? onTap;
  final HitTestBehavior? behavior;

  @override
  Widget build(BuildContext context) {
    ;
    return GetX<CanvasController>(
      init: CanvasController(),
      builder: (ctrl) {
        if (ctrl.widgetsData[index]['matrix'].runtimeType.toString() != 'Float64List') {
          logKey('masih kah');
          ctrl.widgetsData[index]['imageWidgetBool'] = true;
        }

        dynamic tempMatrix = ctrl.widgetsData[index]['matrix'];
        dynamic tempMT = ctrl.widgetsData[index]['matrix_translation'];
        dynamic tempMS = ctrl.widgetsData[index]['matrix_scale'];
        dynamic tempRS = ctrl.widgetsData[index]['matrix_rotation'];

        var a = (ctrl.widgetsData[index]['matrix'] as List).map((item) => item as double).toList();
        tempMatrix = Float64List.fromList(a);
        ctrl.widgetsData[index]['matrix'] = tempMatrix;

        var b = (ctrl.widgetsData[index]['matrix_translation'] as List).map((item) => item as double).toList();
        tempMT = Float64List.fromList(b);
        ctrl.widgetsData[index]['matrix_translation'] = tempMT;

        var c = (ctrl.widgetsData[index]['matrix_scale'] as List).map((item) => item as double).toList();
        tempMS = Float64List.fromList(c);
        ctrl.widgetsData[index]['matrix_scale'] = tempMS;

        var d = (ctrl.widgetsData[index]['matrix_rotation'] as List).map((item) => item as double).toList();
        tempRS = Float64List.fromList(d);
        ctrl.widgetsData[index]['matrix_rotation'] = tempRS;

        return Obx(
          () => MxGestureDetector(
            behavior: behavior,
            shouldRotate: shouldRotate,
            shouldScale: shouldScale,
            shouldTranslate: shouldTranslate,
            onScaleEnd: onScaleEnd,
            focalPointAlignment: Alignment.centerLeft,
            mMatrix: ctrl.widgetsData[index]['imageWidgetBool'] ? Matrix4.fromFloat64List(ctrl.widgetsData[index]['matrix']) : null,
            tMatrix: ctrl.widgetsData[index]['imageWidgetBool'] ? Matrix4.fromFloat64List(ctrl.widgetsData[index]['matrix_translation']) : null,
            sMatrix: ctrl.widgetsData[index]['imageWidgetBool'] ? Matrix4.fromFloat64List(ctrl.widgetsData[index]['matrix_scale']) : null,
            rMatrix: ctrl.widgetsData[index]['imageWidgetBool'] ? Matrix4.fromFloat64List(ctrl.widgetsData[index]['matrix_rotation']) : null,
            undoz: ctrl.widgetsData[index]['imageWidgetBool'],
            onTap: onTap,
            onMatrixUpdate: (m, tm, sm, rm) {
              callBack(m, tm, sm, rm);
              var _temp = MxGestureDetector.compose(
                m,
                tm,
                sm,
                rm,
              );
              var asd = MxGestureDetector.decomposeToValues(_temp);
              logKey('overlay scale', asd.scale);
              // var a = MxGestureDetector.decomposeToValues(_temp);
              // logKey('overlay rotation', a.rotation);
              // notifier!.value = m;
              // rotationNotifier!.value = a.rotation;
              // dxNotifier!.value = a.translation.dx;
              // dyNotifier!.value = a.translation.dy;
            },
            // child: AnimatedBuilder(
            //   animation: notifier!,
            //   // animation: asd!,
            //   builder: (ctx, childWidget) {
            //     // return Transform(
            //     //   transform: notifier!.value,
            //     //   child: Align(
            //     //     alignment: Alignment.center,
            //     //     child: child,
            //     //   ),
            //     // );
            //     return Transform.translate(
            //       offset: Offset.zero,
            //       child: Transform.rotate(
            //         angle: rotationNotifier!.value,
            //         // angle: 0,
            //         child: child,
            //       ),
            //     );
            //   },
            // ),
            child: child,
          ),
        );
      },
    );
  }
}
