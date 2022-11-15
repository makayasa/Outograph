import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/models/draw_pont.dart';

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({
    required this.drawPoints,
  });
  final List<DrawPoint?> drawPoints;
  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) async {
    var _paint = Paint();

    canvas.saveLayer(Rect.fromLTWH(0, 0, Get.width + 80, Get.height + 65), Paint());

    for (var i = 0; i < drawPoints.length - 1; i++) {
      if (drawPoints[i] != null && drawPoints[i + 1] != null) {
        if (!drawPoints[i]!.isDraw) {
          canvas.drawLine(
            Offset(drawPoints[i]!.dx, drawPoints[i]!.dy),
            Offset(drawPoints[i + 1]!.dx, drawPoints[i + 1]!.dy),
            Paint()
              ..color = Colors.brown
              ..strokeWidth = drawPoints[i]!.stroke
              ..blendMode = BlendMode.clear,
          );
        } else {
          PaintingStyle _style = PaintingStyle.fill;
          if (drawPoints[i]!.style == 'stroke') {
            _style = PaintingStyle.stroke;
          }
          _paint.blendMode = BlendMode.srcOver;
          _paint.isAntiAlias = true;
          _paint.style = _style;
          _paint.strokeWidth = drawPoints[i]!.stroke;
          _paint.color = Color(drawPoints[i]!.color);
          Path path = Path();
          path..lineTo(drawPoints[i]!.dx, drawPoints[i + 1]!.dx);
          // path..addPath(path, Offset(drawPoints[i]!.dx, drawPoints[i]!.dy));
          // path..addPath(path, Offset(drawPoints[i + 1]!.dx, drawPoints[i + 1]!.dy));
          // canvas.drawPath(path, _paint);

          canvas.drawLine(
            Offset(drawPoints[i]!.dx, drawPoints[i]!.dy),
            Offset(drawPoints[i + 1]!.dx, drawPoints[i + 1]!.dy),
            _paint,
          );

          if (drawPoints[i]!.stroke >= 3) {
            canvas.drawCircle(Offset(drawPoints[i]!.dx, drawPoints[i]!.dy), (drawPoints[i]!.stroke / 20), _paint);
          } else if (drawPoints[i]!.stroke >= 10) {
            canvas.drawCircle(Offset(drawPoints[i]!.dx, drawPoints[i]!.dy), (drawPoints[i]!.stroke / 30), _paint);
          }
        }
      }
      // else if (drawPoints[i] != null && drawPoints[i + 1] == null) {
      //   var _paint = Paint();
      //   PaintingStyle _style = PaintingStyle.fill;
      //   if (drawPoints[i]!.style == 'stroke') {
      //     _style = PaintingStyle.stroke;
      //   }
      //   _paint.style = _style;
      //   _paint.strokeWidth = drawPoints[i]!.stroke;
      //   _paint.color = Color(drawPoints[i]!.color);
      //   offsetsList.clear();
      //   offsetsList.add(
      //     Offset(drawPoints[i]!.dx, drawPoints[i]!.dy),
      //   );
      //   canvas.drawPoints(
      //     PointMode.points,
      //     offsetsList,
      //     _paint,
      //   );
      // }
    }
    canvas.restore();
    // logKey('restore');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
