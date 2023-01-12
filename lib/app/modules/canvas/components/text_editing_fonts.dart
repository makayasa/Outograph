import 'package:Outograph/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/default_text.dart';

class TextEditingFonts extends GetView<CanvasController> {
  const TextEditingFonts({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(
        () => ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shrinkWrap: true,
          itemCount: controller.listFonts.length,
          // itemCount: 20,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                var activeIndex = controller.getIndexActiveTextEdit();
                controller.widgetsData[activeIndex]['data']['fontFamily'] = controller.listFonts[index];
                controller.widgetsData.refresh();
              },
              child: Container(
                child: DefText(
                  controller.listFonts[index],
                  customStyle: GoogleFonts.getFont(
                    controller.listFonts[index],
                  ),
                ).large,
              ),
            );
          },
        ),
      ),
    );
  }
}
