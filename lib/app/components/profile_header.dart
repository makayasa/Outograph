import 'package:flutter/material.dart';
import 'package:outograph/app/config/constants.dart';

import 'default_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    this.isPreview = false,
  });
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 5),
          //* following row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  DefText('Following').normal,
                  SizedBox(height: 5),
                  DefText(
                    '128',
                    fontWeight: FontWeight.bold,
                  ).semilarge,
                ],
              ),
              SizedBox(width: 25),
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/profile.png',
                  ),
                ),
                // child: Image.asset(
                //   'assets/images/default_picture.jpeg',
                //   fit: BoxFit.cover,
                // ),
              ),
              SizedBox(width: 25),
              Column(
                children: [
                  DefText('Followers').normal,
                  SizedBox(height: 5),
                  DefText(
                    '93',
                    fontWeight: FontWeight.bold,
                  ).semilarge,
                ],
              ),
            ],
          ),
          //* for header in profile
          Visibility(
            visible: !isPreview,
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 10),
                    DefText('Pinned').normal,
                    Spacer(),
                    DefText('Michel JayBay').normal,
                    SizedBox(width: 5),
                    Icon(
                      Icons.more_vert,
                      color: kBgBlack,
                    ),
                    Spacer(),
                    DefText('Tag').normal,
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          //* for header in preview post
          Visibility(
            visible: isPreview,
            child: Column(
              children: [
                SizedBox(height: 10),
                //* name for preview post
                DefText(
                  'miss_chan',
                  fontWeight: FontWeight.bold,
                ).normal,
                SizedBox(height: 10),
                DefText('Misa Hana Lestari').normal,
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      DefText(
                        '63',
                        fontWeight: FontWeight.bold,
                      ).normal,
                      SizedBox(width: 5),
                      DefText('Impressions').normal,
                      Spacer(),
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
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                //* Pinned, canvas, tag
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DefText('Pinned').normal,
                      Row(
                        children: [
                          DefText('Canvas').normal,
                          Container(
                            height: 10,
                            child: Switch(
                              value: true,
                              activeColor: kBgBlack,
                              activeTrackColor: kInactiveColor,
                              onChanged: (value) {},
                            ),
                          )
                        ],
                      ),
                      DefText('Tag').normal,
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
