class GifWidgetModel {
  GifWidgetModel({
    required this.url,
    this.x_axis = 0.0,
    this.y_axis = 0.0,
    this.scale = 0.0,
    this.rotation = 0.0,
  });

  String url;
  double x_axis;
  double y_axis;
  double scale;
  double rotation;

  factory GifWidgetModel.fromJson(Map<String, dynamic> json) => GifWidgetModel(
        url: json['url'],
        x_axis: json['x_axis'],
        y_axis: json['y_axis'],
        scale: json['scale'],
        rotation: json['angle_rotation'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'x_axis': x_axis,
        'y_axis': y_axis,
        'scale': scale,
        'angle_rotation': rotation,
      };
}
