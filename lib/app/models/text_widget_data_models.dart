import 'package:outograph/app/helpers/text_align_helper.dart';

class TextWidgetDataModels {
  TextWidgetDataModels({
    required this.text,
    required this.fontSize,
    this.lineHeight = 1,
    this.fontFamily = 'Montserrat',
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.textAlign = TextAlignHelper.START,
    this.color = 0xFF191508,
  });

  String text;
  double? fontSize = 20;
  double lineHeight;
  String? fontFamily;
  bool isBold;
  bool isItalic;
  bool isUnderline;
  String textAlign;
  int color;

  factory TextWidgetDataModels.fromJson(Map<String, dynamic> json) => TextWidgetDataModels(
        text: json['text'],
        fontSize: json['fontSize'],
        lineHeight: json['lineHeight'],
        fontFamily: json['fontFamily'],
        isBold: json['isBold'],
        isItalic: json['isItalic'],
        isUnderline: json['isUnderline'],
        textAlign: json['textAlign'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'fontSize': fontSize,
        'lineHeight': lineHeight,
        'fontFamily': fontFamily,
        'isBold': isBold,
        'isItalic': isItalic,
        'isUnderline': isUnderline,
        'textAlign': textAlign,
        'color': color,
      };
}
