import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/config/constants.dart';
import 'package:outograph/app/modules/canvas/controllers/canvas_controller.dart';

class CanvasFontList extends GetView<CanvasController> {
  const CanvasFontList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgWhite,
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            color: Colors.amber,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
