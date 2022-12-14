import 'dart:convert';
import 'dart:typed_data';

CanvasItemModels canvasItemModelsFromJson(String str) => CanvasItemModels.fromJson(json.decode(str));

String canvasItemModelsToJson(CanvasItemModels data) => json.encode(data.toJson());

class CanvasItemModels {
  CanvasItemModels({
    required this.type,
    required this.data,
    required this.imageWidgetBool,
    required this.editMode,
    required this.canRotate,
    required this.canResize,
    this.canTranslate = true,
    this.dx = 0.0,
    this.dy = 0.0,
    this.configDx = 0.0,
    this.configDy = 0.0,
    this.scale = 1.0,
    this.rotation = 0.0,
    required this.color,
    required this.matrix,
    required this.matrixTranslation,
    required this.matrixScale,
    required this.matrixRotaion,
    this.topEdge = 0.0,
    this.bottomEdge = 0.0,
    this.leftEdge = 0.0,
    this.rightEdge = 0.0,
  });

  String type;
  Map<String, dynamic> data;

  //* boolean ini agar saat matrix terjadi perubahan diluar dari gesture detector
  //* tidak flicker saat event gesture detector terjadi kembali
  //* jadikan true jika ada perbuahan matrix
  bool imageWidgetBool;

  bool editMode;
  bool canRotate;
  bool canResize;
  bool canTranslate;
  double dx;
  double dy;
  double configDx;
  double configDy;
  double scale;
  double rotation;
  int color;
  Float64List matrix;
  Float64List matrixTranslation;
  Float64List matrixScale;
  Float64List matrixRotaion;
  double topEdge;
  double bottomEdge;
  double leftEdge;
  double rightEdge;

  factory CanvasItemModels.fromJson(Map<String, dynamic> json) => CanvasItemModels(
        type: json["type"],
        data: json['data'],
        imageWidgetBool: json["imageWidgetBool"],
        editMode: json["edit_mode"],
        canRotate: json["can_rotate"],
        canResize: json["can_resize"],
        canTranslate: json['can_translate'],
        dx: json["dx"],
        dy: json["dy"],
        configDx: json['configDx'],
        configDy: json['configDy'],
        scale: json["scale"],
        rotation: json["rotation"],
        color: json["color"],
        matrix: Float64List.fromList((json['matrix'] as List).map((e) => e as double).toList()),
        matrixTranslation: Float64List.fromList((json['matrix_translation'] as List).map((e) => e as double).toList()),
        matrixScale: Float64List.fromList((json['matrix_scale'] as List).map((e) => e as double).toList()),
        matrixRotaion: Float64List.fromList((json['matrix_rotation'] as List).map((e) => e as double).toList()),
        topEdge: json['top_edge'],
        bottomEdge: json['bottom_edge'],
        leftEdge: json['left_edge'],
        rightEdge: json['right_edge'],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
        "imageWidgetBool": imageWidgetBool,
        "edit_mode": editMode,
        "can_rotate": canRotate,
        "can_resize": canResize,
        'can_translate': canTranslate,
        "dx": dx,
        "dy": dy,
        'configDx': configDx,
        'configDy': configDy,
        "scale": scale,
        "rotation": rotation,
        "color": color,
        "matrix": matrix,
        "matrix_translation": matrixTranslation,
        "matrix_scale": matrixScale,
        "matrix_rotation": matrixRotaion,
        'top_edge': topEdge,
        'bottom_edge': bottomEdge,
        'left_edge': leftEdge,
        'right_edge': rightEdge,
      };
}
