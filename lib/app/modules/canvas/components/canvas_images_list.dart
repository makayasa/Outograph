import 'package:Outograph/app/config/constants.dart';
import 'package:Outograph/app/helpers/canvas_helper.dart';
import 'package:Outograph/app/modules/canvas/controllers/canvas_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class CanvasImagesList extends GetView<CanvasController> {
  const CanvasImagesList({
    super.key,
    // required this.scrollController,
  });
  // final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgWhite,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (controller.panelImageController.panelPosition == 0) {
                controller.panelImageController.animatePanelToPosition(1);
              } else {
                controller.panelImageController.animatePanelToPosition(0);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Center(
                child: Container(
                  height: 10,
                  width: 100,
                  decoration: BoxDecoration(
                    color: kInactiveColor,
                    borderRadius: kDefaultBorderRadius10,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => GridView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller.imageScrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: controller.listImages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      var path = await controller.listImages[index].file;
                      await controller.closeImage();
                      controller.botNavIndex.value = -1;
                      controller.addWidget(
                        type: CanvasItemType.IMAGE,
                        data: path!.path,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: kBgBlack,
                          ),
                          left: BorderSide(
                            color: kBgBlack,
                          ),
                        ),
                      ),
                      child: AssetEntityImage(
                        controller.listImages[index],
                        isOriginal: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
