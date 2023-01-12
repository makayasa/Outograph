import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:outograph/app/components/canvas_item_global.dart';

class TimelineItem extends StatelessWidget {
  const TimelineItem({
    required this.data,
    super.key,
  });
  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Positioned(
        left: data['x_axis'].toDouble(),
        top: data['y_axis'].toDouble(),
        child: Transform.rotate(
          angle: data['angle_rotation'].toDouble(),
          child: Transform.scale(
            scale: data['scale'].toDouble(),
            child: Container(
              child: CanvasItemGlobal(
                data: data,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
