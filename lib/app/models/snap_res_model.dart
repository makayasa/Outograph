class SnapResModel {
  SnapResModel({
    required this.trigger,
    required this.isBottom,
    required this.isTop,
    required this.isLeft,
    required this.isRight,
  });
  bool trigger;
  bool isBottom;
  bool isTop;
  bool isLeft;
  bool isRight;

  factory SnapResModel.fromJson(Map<String, dynamic> json) => SnapResModel(
        trigger: json['trigger'],
        isBottom: json['isBottom'],
        isTop: json['isTop'],
        isLeft: json['isLeft'],
        isRight: json['isRight'],
      );

  Map<String, dynamic> toJson() => {
        'trigger': trigger,
        'isBottom': isBottom,
        'isTop': isTop,
        'isLeft': isLeft,
        'isRight': isRight,
      };
}
