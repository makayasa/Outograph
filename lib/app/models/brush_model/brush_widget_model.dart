import 'package:Outograph/app/helpers/canvas_helper.dart';

class BrushWidgetModel {
  BrushWidgetModel({
    required this.index,
    required this.drawpoint,
    required this.base64,
    this.type = CanvasItemType.BRUSH,
  });
  int index;
  List drawpoint;
  String base64;
  String type;

  factory BrushWidgetModel.fromJson(Map<String, dynamic> json) => BrushWidgetModel(
        index: json['index'],
        type: json['type'],
        drawpoint: json['drawpoint'],
        base64: json['base64'],
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        'type': type,
        'drawpoint': drawpoint,
        'base64': base64,
      };
}
