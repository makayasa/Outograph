import 'dart:convert';

import 'package:Outograph/app/models/text_model/text_font_model.dart';

TextWidgetModels textWidgetModelsFromJson(String str) => TextWidgetModels.fromJson(json.decode(str));

String textWidgetModelsToJson(TextWidgetModels data) => json.encode(data.toJson());

class TextWidgetModels {
  TextWidgetModels({
    required this.type,
    required this.index,
    required this.font,
    // required this.imageWidgetBool,
    // required this.editMode,
    // required this.canRotate,
    // required this.canResize,
    required this.x_axis,
    required this.y_axis,
    required this.scale,
    required this.rotation,
    // required this.color,
    required this.longText,
    required this.shortText,
    // required this.matrix,
    // required this.matrixTranslation,
    // required this.matrixScale,
    // required this.matrixRotaion,
  });

  String type;
  int index;
  TextFontModel font;
  // bool imageWidgetBool;
  // bool editMode;
  // int color;
  String longText;
  String shortText;

  // bool canRotate;
  // bool canResize;
  double x_axis;
  double y_axis;
  double scale;
  double rotation;
  // Float64List matrix;
  // Float64List matrixTranslation;
  // Float64List matrixScale;
  // Float64List matrixRotaion;

  factory TextWidgetModels.fromJson(Map<String, dynamic> json) => TextWidgetModels(
        type: json["type"],
        index: json['index'],
        longText: json['long_text'],
        shortText: json['short_text'],
        font: TextFontModel.fromJson(json['font']),
        // imageWidgetBool: json["imageWidgetBool"],
        // editMode: json["edit_mode"],
        // canRotate: json["can_rotate"],
        // canResize: json["can_resize"],
        x_axis: json["x_axis"].toDouble(),
        y_axis: json["y_axis"].toDouble(),
        scale: json["scale"].toDouble(),
        rotation: json["angle_rotation"].toDouble(),
        // color: json["color"],
        // matrix: Float64List.fromList((json['matrix'] as List).map((e) => e as double).toList()),
        // matrixTranslation: Float64List.fromList((json['matrix_translation'] as List).map((e) => e as double).toList()),
        // matrixScale: Float64List.fromList((json['matrix_scale'] as List).map((e) => e as double).toList()),
        // matrixRotaion: Float64List.fromList((json['matrix_rotation'] as List).map((e) => e as double).toList()),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        'index': index,
        'long_text': longText,
        'short_text': shortText,
        'font': font.toJson(),
        // "imageWidgetBool": imageWidgetBool,
        // "edit_mode": editMode,
        // "can_rotate": canRotate,
        // "can_resize": canResize,
        "x_axis": x_axis,
        "y_axis": y_axis,
        "scale": scale,
        "angle_rotation": rotation,
        // "color": color,
        // "matrix": matrix,
        // "matrix_translation": matrixTranslation,
        // "matrix_scale": matrixScale,
        // "matrix_rotation": matrixRotaion,
      };
}
