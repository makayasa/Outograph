import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/routes/app_pages.dart';
import 'package:outograph/app/utils/function_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: DefText(
          'HomeView',
        ).large,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // controller.deleteTimeline();
          var a = hexToColor('#e8ba3a');
          logKey(
            'asd',
            a.value,
          );
        },
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.CANVAS);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DefText('Canvas').normal,
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.TIMELINE);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    color: hexToColor('#2366a6'),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DefText('Timeline').normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
