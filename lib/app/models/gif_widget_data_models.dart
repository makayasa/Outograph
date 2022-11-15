class GifWidgetDataModels {
  GifWidgetDataModels({
    required this.url,
  });
  String url;

  factory GifWidgetDataModels.fromJson(Map<String, dynamic> json) => GifWidgetDataModels(
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
      };
}
