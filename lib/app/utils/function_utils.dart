import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Matrix4 translate(Offset translation) {
  var dx = translation.dx;
  var dy = translation.dy;

  //  ..[0]  = 1       # x scale
  //  ..[5]  = 1       # y scale
  //  ..[10] = 1       # diagonal "one"
  //  ..[12] = dx      # x translation
  //  ..[13] = dy      # y translation
  //  ..[15] = 1       # diagonal "one"
  return Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
}

Matrix4 scale(double scale, Offset focalPoint) {
  var dx = (1 - scale) * focalPoint.dx;
  var dy = (1 - scale) * focalPoint.dy;

  //  ..[0]  = scale   # x scale
  //  ..[5]  = scale   # y scale
  //  ..[10] = 1       # diagonal "one"
  //  ..[12] = dx      # x translation
  //  ..[13] = dy      # y translation
  //  ..[15] = 1       # diagonal "one"
  return Matrix4(scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
}

Matrix4 rotate(double angle, Offset focalPoint) {
  var c = cos(angle);
  var s = sin(angle);
  var dx = (1 - c) * focalPoint.dx + s * focalPoint.dy;
  var dy = (1 - c) * focalPoint.dy - s * focalPoint.dx;

  //  ..[0]  = c       # x scale
  //  ..[1]  = s       # y skew
  //  ..[4]  = -s      # x skew
  //  ..[5]  = c       # y scale
  //  ..[10] = 1       # diagonal "one"
  //  ..[12] = dx      # x translation
  //  ..[13] = dy      # y translation
  //  ..[15] = 1       # diagonal "one"
  return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
}

bool isEmpty(dynamic val) {
  return [
    "",
    " ",
    null,
    'null',
    '{}',
    '[]',
    '0',
    '0.0',
  ].contains(val.toString());
}

bool isNotEmpty(dynamic val) {
  return ![
    "",
    " ",
    null,
    'null',
    '{}',
    '[]',
    '0',
    '0.0',
    '0.00',
  ].contains(val.toString());
}

void logKey([key, content]) {
  String finalLog = '';
  dynamic tempContent = content ?? key;
  if (tempContent is Map || tempContent is List) {
    try {
      finalLog = json.encode(tempContent);
    } catch (e) {
      finalLog = tempContent.toString();
    }
  } else if (tempContent is String) {
    finalLog = tempContent;
  } else {
    finalLog = tempContent.toString();
  }

  if (content != null) {
    dev.log('$key => $finalLog');
  } else {
    dev.log(finalLog);
  }
}

void name(args) {
  Map b = {};
  Function(Map) a = ((p0) {});
  a(b);
}

typedef OnUpdate<T> = T Function(T oldValue, T newValue);

class ValueUpdater<T> {
  final OnUpdate<T> onUpdate;
  T value;

  ValueUpdater({
    required this.value,
    required this.onUpdate,
  });

  T update(T newValue) {
    T updated = onUpdate(value, newValue);
    value = newValue;
    return updated;
  }
}

void toJsonA(String arg) {}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

void showToast(message, {bgColor, txtColor}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      // ?? kPrimaryColor,
      textColor: txtColor ?? Colors.white,
      fontSize: 12.0);
}

Map getSizeByKey(GlobalKey key) {
  final RenderBox a = key.currentContext!.findRenderObject()! as RenderBox;
  return {
    "height": a.size.height,
    "width": a.size.width,
  };
}

Future<String> drawerToImage(drawPoint) async {
  ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  var _paint = Paint();
  Canvas canvas = Canvas(pictureRecorder);
  for (var i = 0; i < drawPoint.length - 1; i++) {
    if (drawPoint[i] != null && drawPoint[i + 1] != null) {
      if (!drawPoint[i]!.isDraw) {
        canvas.drawLine(
          Offset(drawPoint[i]!.dx, drawPoint[i]!.dy),
          Offset(drawPoint[i + 1]!.dx, drawPoint[i + 1]!.dy),
          Paint()
            ..color = Colors.brown
            ..strokeWidth = drawPoint[i]!.stroke
            ..blendMode = BlendMode.clear,
        );
      } else {
        PaintingStyle _style = PaintingStyle.fill;
        if (drawPoint[i]!.style == 'stroke') {
          _style = PaintingStyle.stroke;
        }
        _paint.blendMode = BlendMode.srcOver;
        _paint.isAntiAlias = true;
        _paint.style = _style;
        _paint.strokeWidth = drawPoint[i]!.stroke;
        _paint.color = Color(drawPoint[i]!.color);
        Path path = Path();
        path..lineTo(drawPoint[i]!.dx, drawPoint[i + 1]!.dx);

        canvas.drawLine(
          Offset(drawPoint[i]!.dx, drawPoint[i]!.dy),
          Offset(drawPoint[i + 1]!.dx, drawPoint[i + 1]!.dy),
          _paint,
        );

        if (drawPoint[i]!.stroke >= 3) {
          canvas.drawCircle(Offset(drawPoint[i]!.dx, drawPoint[i]!.dy), (drawPoint[i]!.stroke / 20), _paint);
        } else if (drawPoint[i]!.stroke >= 10) {
          canvas.drawCircle(Offset(drawPoint[i]!.dx, drawPoint[i]!.dy), (drawPoint[i]!.stroke / 30), _paint);
        }
      }
    }
  }
  final picture = pictureRecorder.endRecording();
  // final img = await picture.toImage(Get.width.ceil(), Get.height.ceil());
  // final img = await picture.toImage(1920, 1080);
  final img = await picture.toImage(1920, 1080);
  final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
  // final pngBytes = await img.toByteData(format: ImageByteFormat.rawStraightRgba);
  final base64 = base64Encode(Uint8List.view(pngBytes!.buffer));
  return base64;
}

//? Fungsi untuk ambil gambar dari kamera.
//? Return null jika permission not granted / user tidak jadi mengambil gambar
Future<File?> getImageCamera() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    var newStatus = await Permission.camera.request();
    if (!newStatus.isGranted) {
      return null;
    }
  }
  var img = await ImagePicker().pickImage(
    source: ImageSource.camera,
  );
  if (img == null) {
    return null;
  }
  return File(img.path);
}
