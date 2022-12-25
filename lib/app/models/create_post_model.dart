import 'package:outograph/app/models/gif_model/gif_widget_model.dart';
import 'package:outograph/app/models/text_model/text_widget_models.dart';

import 'image_model/image_widget_model.dart';

class CreatePostModel {
  CreatePostModel({
    this.caption = '',
    this.userCanvasTarget = '',
    required this.width,
    required this.height,
    required this.gifs,
    required this.images,
    required this.texts,
    required this.hastags,
    required this.peoples,
  });
  String caption;
  String userCanvasTarget;
  double width;
  double height;
  List<GifWidgetModel> gifs;
  List<ImageWidgetModel> images;
  List<TextWidgetModels> texts;
  List hastags;
  List peoples;

  factory CreatePostModel.fromJson(Map<String, dynamic> json) => CreatePostModel(
        caption: json['caption'],
        userCanvasTarget: json['user_canvas_target'],
        width: json['width'],
        height: json['height'],
        gifs: json['gifs'],
        images: json['images'],
        texts: json['texts'],
        hastags: json['hastags'],
        peoples: json['peoples'],
      );

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'user_canvas_target': userCanvasTarget,
        'width': width,
        'height': height,
        'gifs': gifs,
        'images': images,
        'text': texts,
        'hastags': hastags,
        'peoples': peoples,
      };
}
