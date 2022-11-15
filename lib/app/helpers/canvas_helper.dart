class CanvasItemType {
  CanvasItemType._();
  static const String IMAGE = 'IMAGE';
  static const String ART = 'ART';
  static const String GIF = 'GIF';
  static const String TEXT = 'TEXT';
  static const String BACKGROUND = 'BACKGROUND';
  static const String BRUSH = 'BRUSH';
  static const String BRUSH_BASE = 'BRUSH_BASE';

  static String helper(String value) {
    if (value == IMAGE) {
      return 'image';
    }
    if (value == ART) {
      return 'art';
    }
    if (value == GIF) {
      return 'gif';
    }
    if (value == TEXT) {
      return 'text';
    }
    if (value == BACKGROUND) {
      return 'background';
    }
    if (value == BRUSH) {
      return 'brush';
    }
    if (value == BRUSH_BASE) {
      return 'brush base';
    }
    return '-';
  }
}
