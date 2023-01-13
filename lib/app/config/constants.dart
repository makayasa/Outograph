import 'package:flutter/material.dart';

// const giphyKey = 'ufpZMP5z8MowSKDSbkWOOOe9zPCIE0Q1';

const kBgWhite = Color(0xFFfafafa);
const kBgBlack = Color(0xFF191508);
const kInactiveColor = Color(0xFFa6a6a6);
const kDefaultPicture = 'assets/images/default_picture.jpeg';

const kUndo = 'undoState';
const kRedo = 'redoState';

TextStyle get kDefaultTextStyle {
  return TextStyle(
    color: kBgBlack,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );
}

const kDefaultPadding = EdgeInsets.only(
  left: 10,
  top: 15,
  right: 10,
);

const kDefaultPaddingB = EdgeInsets.only(
  left: 15,
  top: 15,
  right: 15,
  bottom: 15,
);

const kDefaultBorderRadius = BorderRadius.all(
  Radius.circular(7),
);
const kDefaultBorderRadius10 = BorderRadius.all(
  Radius.circular(10),
);

const textColorList = [
  Color(0xffCF1322),
  Color(0xffF5222D),
  Color(0xffD4380D),
  Color(0xffFA541C),
  Color(0xffAD4E00),
  Color(0xffFA8C16),
  Color(0xffD48806),
  Color(0xffFAAD14),
  Color(0xffD4B106),
  Color(0xffFADB14),
  Color(0xff7CB305),
  Color(0xffA0D911),
  Color(0xff389E0D),
  Color(0xff52C41A),
  Color(0xff08979C),
  Color(0xff13C2C2),
  Color(0xff096DD9),
  Color(0xff1890FF),
  Color(0xff1D39C4),
  Color(0xff2F54EB),
  Color(0xff531DAB),
  Color(0xff722ED1),
  Color(0xffC41D7F),
  Color(0xffEB2F96),
  Color(0xff000000),
  Color(0xff222222),
  Color(0xff595959),
  Color(0xff8C8C8C),
  Color(0xffBFBFBF),
  Color(0xffD9D9D9),
  Color(0xffE8E8E8),
  Color(0xffFAFAFA),
];
