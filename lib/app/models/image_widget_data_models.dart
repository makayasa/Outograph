class ImageWidgetDataModels {
  ImageWidgetDataModels({required this.path});

  String path;

  factory ImageWidgetDataModels.fromJson(Map<String, dynamic> json) => ImageWidgetDataModels(
        path: json['path'],
      );

  Map<String, dynamic> toJson() => {
        'path': path,
      };
}
