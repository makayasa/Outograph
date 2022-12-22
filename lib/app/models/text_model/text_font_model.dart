class TextFontModel {
  TextFontModel({
    required this.fontFamily,
    required this.fontSize,
    required this.fontWeight,
    // required this.color,
    required this.fontType,
    required this.justify,
    required this.lineHeight,
  });

  String fontFamily;
  int fontSize;
  int fontWeight;
  // int color;
  String fontType;
  String justify;
  double lineHeight;

  factory TextFontModel.fromJson(Map<String, dynamic> json) => TextFontModel(
        fontFamily: json['font_family'],
        fontSize: json['font_size'],
        fontWeight: json['font_weight'],
        // color: json['color'],
        fontType: json['font_type'],
        justify: json['justify'],
        lineHeight: json['line_height'],
      );

  Map<String, dynamic> toJson() => {
        "font_family": fontFamily,
        "font_size": fontSize,
        "font_weight": fontWeight,
        // "font_color": color,
        "font_type": fontType,
        "justify": justify,
        "line_height": lineHeight,
      };
}
