import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outograph/app/components/default_text.dart';
import 'package:outograph/app/components/profile_header.dart';
import 'package:outograph/app/components/timeline_item.dart';
import 'package:outograph/app/config/constants.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefText(
          'authorjay',
          fontWeight: FontWeight.bold,
        ).large,
        centerTitle: true,
        elevation: 0,
        leadingWidth: double.infinity,
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              DefText(
                '63',
                fontWeight: FontWeight.bold,
              ).normal,
              SizedBox(width: 5),
              DefText('Impressions').normal,
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: [
                DefText('Post').normal,
                SizedBox(width: 10),
                Image.asset(
                  'assets/icons/add.png',
                  height: 24,
                  width: 24,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.selectedTag.value++;
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  // color: Colors.amber,
                  ),
              child: ListView.builder(
                itemCount: controller.listTag.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      child: Icon(Icons.add),
                    );
                  } else {
                    return Obx(
                      () => Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: kBgBlack,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            top: controller.selectedTag.value == index - 1 ? 1.5 : 0,
                            left: controller.selectedTag.value == index - 1 ? 1.5 : 0,
                            right: controller.selectedTag.value == index - 1 ? 1.5 : 0,
                            bottom: controller.selectedTag.value != index - 1 ? 1.5 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: kBgWhite,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10 - 1.5),
                              topLeft: Radius.circular(10 - 1.5),
                            ),
                          ),
                          child: Center(
                            child: DefText(
                              controller.listTag[index - 1],
                            ).normal,
                          ),
                        ),
                      ),
                    );
                    // return Container(
                    //   padding: EdgeInsets.all(10),
                    //   constraints: BoxConstraints(minWidth: 70),
                    //   decoration: BoxDecoration(
                    //     color: Colors.lightBlue,
                    //     // borderRadius: BorderRadius.only(
                    //     //   topLeft: Radius.circular(10),
                    //     //   topRight: Radius.circular(10),
                    //     // ),
                    //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    //     border: Border(
                    //       top: BorderSide(
                    //         color: Colors.red,
                    //       ),
                    //       left: BorderSide(
                    //         color: Colors.red,
                    //       ),
                    //       right: BorderSide(
                    //         color: Colors.red,
                    //       ),
                    //       bottom: BorderSide(
                    //         color: Colors.transparent,
                    //       ),
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: DefText(
                    //       controller.listTag[index - 1],
                    //     ).normal,
                    //   ),
                    // );
                  }
                },
              ),
              // child: Row(
              //   children: [
              //     Container(
              //       child: Icon(
              //         Icons.add,
              //       ),
              //     ),
              //     Flexible(
              //       child: Container(
              //         height: 50,
              //         decoration: BoxDecoration(
              //           color: Colors.lightBlue,
              //         ),
              //         child: Center(
              //           child: DefText('Traveling World').normal,
              //         ),
              //       ),
              //     ),
              //     Flexible(
              //       child: Container(
              //         height: 50,
              //         decoration: BoxDecoration(
              //           color: Colors.lightBlue,
              //         ),
              //         child: Center(
              //           child: DefText('Traveling World').normal,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ),
            SizedBox(height: 10),
            Obx(
              () => Container(
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.listPosts.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    List items = controller.listPosts[index]['items'];
                    return Container(
                      height: 500,
                      child: Stack(
                        fit: StackFit.expand,
                        children: items
                            .asMap()
                            .map((idx, value) {
                              var data = items[idx];
                              return MapEntry(
                                idx,
                                TimelineItem(data: data),
                              );
                            })
                            .values
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
