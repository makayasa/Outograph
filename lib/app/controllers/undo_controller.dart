import 'package:get/get.dart';

import '../models/draw_pont.dart';

class UndoController extends GetxController {
  RxList<DrawPoint?> redoStateBrush = (List<DrawPoint?>.of([])).obs;
  var undoStatez = [];
}
