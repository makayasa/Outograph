// import 'dart:convert';
// import 'dart:typed_data';

// ImageWidget imageWidgetFromJson(String str) => ImageWidget.fromJson(json.decode(str));

// String imageWidgetToJson(ImageWidget data) => json.encode(data.toJson());

// class ImageWidget {
//   ImageWidget({
//     required this.type,
//     required this.data,
//     required this.imageWidgetBool,
//     required this.editMode,
//     required this.canRotate,
//     required this.canResize,
//     required this.dx,
//     required this.dy,
//     required this.scale,
//     required this.rotation,
//     required this.color,
//     required this.matrix,
//     required this.matrixTranslation,
//     required this.matrixScale,
//     required this.matrixRotaion,
//   });

//   String type;
//   String data;
//   bool imageWidgetBool;
//   bool editMode;
//   bool canRotate;
//   bool canResize;
//   double dx;
//   double dy;
//   double scale;
//   double rotation;
//   int color;
//   Float64List matrix;
//   Float64List matrixTranslation;
//   Float64List matrixScale;
//   Float64List matrixRotaion;

//   factory ImageWidget.fromJson(Map<String, dynamic> json) => ImageWidget(
//         type: json["type"],
//         data: json["data"],
//         imageWidgetBool: json["imageWidgetBool"],
//         editMode: json["edit_mode"],
//         canRotate: json["can_rotate"],
//         canResize: json["can_resize"],
//         dx: json["dx"],
//         dy: json["dy"],
//         scale: json["scale"],
//         rotation: json["rotation"],
//         color: json["color"],
//         matrix: Float64List.fromList((json['matrix'] as List).map((e) => e as double).toList()),
//         matrixTranslation: Float64List.fromList((json['matrix_translation'] as List).map((e) => e as double).toList()),
//         matrixScale: Float64List.fromList((json['matrix_scale'] as List).map((e) => e as double).toList()),
//         matrixRotaion: Float64List.fromList((json['matrix_rotation'] as List).map((e) => e as double).toList()),
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "data": data,
//         "imageWidgetBool": imageWidgetBool,
//         "edit_mode": editMode,
//         "can_rotate": canRotate,
//         "can_resize": canResize,
//         "dx": dx,
//         "dy": dy,
//         "scale": scale,
//         "rotation": rotation,
//         "color": color,
//         "matrix": matrix,
//         "matrix_translation": matrixTranslation,
//         "matrix_scale": matrixScale,
//         "matrix_rotation": matrixRotaion,
//       };
// }
