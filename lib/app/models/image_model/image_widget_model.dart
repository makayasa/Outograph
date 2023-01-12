import 'package:Outograph/app/helpers/canvas_helper.dart';

class ImageWidgetModel {
  ImageWidgetModel({
    required this.index,
    required this.path,
    required this.width,
    required this.height,
    this.type = CanvasItemType.IMAGE,
    this.x_axis = 0.0,
    this.y_axis = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    required this.createdAt,
    this.top_edge,
    this.bottom_edge,
    this.left_edge,
    this.right_edge,
    required this.default_height,
    required this.default_width,
    this.key,
  });
  int index;
  String? key;
  String path;
  double width;
  double height;
  String type;
  double x_axis;
  double y_axis;
  double scale;
  double rotation;
  String createdAt;

  //*untuk kebutuhan canvas
  double? top_edge;
  double? bottom_edge;
  double? left_edge;
  double? right_edge;
  double? default_height;
  double? default_width;

  factory ImageWidgetModel.fromJson(Map<String, dynamic> json) => ImageWidgetModel(
        index: json['index'],
        path: json['path'],
        key: json['key'] ?? '',
        // base64data: json['base64data'],
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        x_axis: json['x_axis'].toDouble(),
        y_axis: json['y_axis'].toDouble(),
        scale: json['scale'].toDouble(),
        rotation: json['angle_rotation'].toDouble(),
        createdAt: json['created_at'],
        top_edge: json['top_edge'] ?? 0.0,
        bottom_edge: json['bottom_edge'] ?? 0.0,
        left_edge: json['left_edge'] ?? 0.0,
        right_edge: json['right_edge'] ?? 0.0,
        default_height: json['default_height'] ?? 0.0,
        default_width: json['default_width'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'index': index,
        "path": path,
        "width": width,
        "height": height,
        // "index": 0,
        'key': key ?? '',
        "type": type,
        "x_axis": x_axis,
        "y_axis": y_axis,
        'scale': scale,
        'angle_rotation': rotation,
        'created_at': createdAt,
        'top_edge': top_edge,
        'bottom_edge': bottom_edge,
        'left_edge': left_edge,
        'right_edge': right_edge,
        'default_height': default_height,
        'default_width': default_width,
      };
}
