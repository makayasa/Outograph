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
        'background': {
          "color": "123123",
          "key": "istockphoto-1369271869-612x612.jpg",
        },
        'hastags': hastags,
        // 'peoples': peoples,
        'peoples': [
          {"user_id": "63371580b9ef8ae07fc631c0"},
          {"user_id": "6337b93ab9ef8ae07fc631c4"}
        ],
      };
}
