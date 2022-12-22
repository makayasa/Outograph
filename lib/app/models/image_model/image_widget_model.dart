import 'package:outograph/app/helpers/canvas_helper.dart';

class ImageWidgetModel {
  ImageWidgetModel({
    required this.url,
    required this.width,
    required this.height,
    this.type = CanvasItemType.IMAGE,
    this.x_axis = 0.0,
    this.y_axis = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    required this.createdAt,
  });
  String url;
  double width;
  double height;
  String type;
  double x_axis;
  double y_axis;
  double scale;
  double rotation;
  String createdAt;

  factory ImageWidgetModel.fromJson(Map<String, dynamic> json) => ImageWidgetModel(
        url: json['url'],
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        x_axis: json['x_axis'].toDouble(),
        y_axis: json['y_axis'].toDouble(),
        scale: json['scale'].toDouble(),
        rotation: json['angle_rotation'].toDouble(),
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
        // "index": 0,
        "type": type,
        "x_axis": x_axis,
        "y_axis": y_axis,
        'scale': scale,
        'angle_rotation': rotation,
        "created_at": createdAt,
      };
}
