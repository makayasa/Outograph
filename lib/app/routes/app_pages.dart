import 'package:Outograph/app/modules/canvas/bindings/canvas_binding.dart';
import 'package:Outograph/app/modules/canvas/views/canvas_view.dart';
import 'package:Outograph/app/modules/canvas_preview/bindings/canvas_preview_binding.dart';
import 'package:Outograph/app/modules/canvas_preview/views/canvas_preview_view.dart';
import 'package:Outograph/app/modules/home/bindings/home_binding.dart';
import 'package:Outograph/app/modules/home/views/home_view.dart';
import 'package:Outograph/app/modules/profile/bindings/profile_binding.dart';
import 'package:Outograph/app/modules/profile/views/profile_view.dart';
import 'package:Outograph/app/modules/timeline/bindings/timeline_binding.dart';
import 'package:Outograph/app/modules/timeline/views/timeline_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CANVAS,
      page: () => CanvasView(),
      binding: CanvasBinding(),
    ),
    GetPage(
      name: _Paths.TIMELINE,
      page: () => TimelineView(),
      binding: TimelineBinding(),
    ),
    GetPage(
      name: _Paths.CANVAS_PREVIEW,
      page: () => CanvasPreviewView(),
      binding: CanvasPreviewBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
