import 'package:outograph/app/models/gif_model/gif_widget_model.dart';
import 'package:outograph/app/models/text_model/text_widget_models.dart';

import 'image_model/image_widget_model.dart';

class CreatePostModel {
  CreatePostModel({
    this.caption = '',
    this.userCanvasTarget = '',
    required this.width,
    required this.height,
    required this.topHeight,
    required this.bottomHeight,
    required this.gifs,
    required this.images,
    required this.texts,
    required this.brush,
    required this.hastags,
    required this.peoples,
  });
  String caption;
  String userCanvasTarget;
  double width;
  double height;
  double topHeight;
  double bottomHeight;
  List<GifWidgetModel> gifs;
  List<ImageWidgetModel> images;
  List<TextWidgetModels> texts;
  // BrushWidgetModel brush;
  Map<String, dynamic> brush;
  List hastags;
  List peoples;

  factory CreatePostModel.fromJson(Map<String, dynamic> json) => CreatePostModel(
        caption: json['caption'],
        userCanvasTarget: json['user_canvas_target'],
        width: json['width'],
        height: json['height'],
        topHeight: json['top_height'],
        bottomHeight: json['bottom_height'],
        gifs: json['gifs'],
        images: json['images'],
        texts: json['texts'],
        brush: json['brush'],
        hastags: json['hastags'],
        peoples: json['peoples'],
      );

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'user_canvas_target': userCanvasTarget,
        'width': width,
        'height': height,
        'top_height': topHeight,
        'bottom_height': bottomHeight,
        'gifs': gifs,
        'images': images,
        'texts': texts,
        'brush': brush,
        'hastags': hastags,
        'peoples': peoples,
      };
}
