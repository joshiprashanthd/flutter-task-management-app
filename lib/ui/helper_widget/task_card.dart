import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';

import '../util/CustomColors.dart';
import '../../core/models/task.dart';
import 'custom_flat_button.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key key, this.task})
      : assert(task != null),
        super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final iconSize = width * 0.1;

    return Container(
      width: width * 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(-1, 3),
            color: Colors.grey.shade300,
            blurRadius: 3,
          )
        ],
        // border: Border.all(width: 2, color: Colors.black),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Hero(
            tag: task.id.toString(),
            child: ClipOval(
              child: Container(
                width: iconSize + 20,
                height: iconSize + 20,
                color: task.taskColor,
                child: Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ),
          Spacer(flex: 1),
          Text(
              task.title,
              overflow: TextOverflow.fade,
              maxLines:
                  task.subtasks == null || task.subtasks.length == 0 ? 2 : 1,
              style: TextStyle(
                fontSize: width * SizeRatio.heading1RatioWidth,
                fontWeight: FontWeight.w700,
                color: CustomColor.primaryTextColor,
              ),
            ),
          task.subtasks == null || task.subtasks.length == 0
              ? Container()
              : Text(
                  "${task.totalSubtasks - task.subtaskCompleted} Subtasks Remaining",
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: width * SizeRatio.subheading4RatioWidth,
                    color: CustomColor.primarySubheadingTextColor,
                  ),
                ),
          SizedBox(
            height: 8.0,
          ),
          CustomPaint(
            painter: LinePainter(
                task.totalSubtasks, task.subtaskCompleted, task.taskColor),
            child: Container(
              width: width,
              height: 4.0,
            ),
          ),
          Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomFlatButton(
                highlightElevation: 2,
                color: task.taskColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  "SHOW",
                  style: TextStyle(
                    fontSize: width * SizeRatio.subheading4RatioWidth,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/task_show_page',
                      arguments: task.id);
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                iconSize: iconSize * 0.7,
                color: CustomColor.primaryIconColor,
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final int totalTasks;
  final int taskCompleted;
  final Color color;

  LinePainter(this.totalTasks, this.taskCompleted, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    if (totalTasks > 0) {
      canvas.drawLine(
          Offset(3, 0),
          Offset(
              totalTasks < taskCompleted
                  ? width
                  : 3 + (taskCompleted / totalTasks) * width,
              0),
          paint);
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LinePainter oldDelegate) => false;
}
