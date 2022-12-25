class ImageCanvasModel {
  ImageCanvasModel({
    required this.width,
    required this.height,
    required this.index,
    required this.x_axis,
    required this.y_axis,
    required this.scale,
    required this.rotation,
  });

  double width;
  double height;
  int index;
  double x_axis;
  double y_axis;
  double scale;
  double rotation;

  factory ImageCanvasModel.fromJson(Map<String, dynamic> json) => ImageCanvasModel(
        width: json['width'],
        height: json['height'],
        index: json['index'],
        x_axis: json['x_axis'],
        y_axis: json['y_axis'],
        scale: json['scale'],
        rotation: json['angle_rotation'],
      );

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'index': index,
        'x_axis': x_axis,
        'y_axis': y_axis,
        'scale': scale,
        'angle_rotation': rotation,
      };
}
