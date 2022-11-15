class DrawPoint {
  // DrawPoint({required this.offset, required this.paint});
  // Offset offset;
  // Paint paint;

  DrawPoint({
    required this.dx,
    required this.dy,
    this.stroke = 8,
    this.color = 0xfff44336,
    this.isDraw = true,
    required this.style,
  });

  double dx;
  double dy;
  double stroke;
  int color;
  String style;
  bool isDraw;

  // @override
  // toString() => '{"offset": $offset, "paint":$paint}';

  @override
  String toString() => '{"dx":$dx, "dy":$dy, "paint":{"isDraw":$isDraw,"color":$color, "stroke":${stroke.toStringAsFixed(1)}, "style":"$style"}}';

  Map<String, dynamic> toJson() => {
        "dx": dx,
        "dy": dy,
        "paint": {
          "isDraw": isDraw,
          "color": color,
          "stroke": stroke,
          "style": style,
        },
      };

  factory DrawPoint.fromJson(Map<String, dynamic> json) => DrawPoint(
        dx: json["dx"].toDouble(),
        dy: json["dy"].toDouble(),
        isDraw: json['paint']['isDraw'],
        color: json['paint']['color'],
        stroke: json['paint']['stroke'],
        style: json['paint']['style'],
      );
}
