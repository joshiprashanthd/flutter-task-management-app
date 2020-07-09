import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/subtask.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/subtask_adder_modal_sheet.dart';
import 'package:first_team_project/ui/helper_widget/tag.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SubtaskDetailModalSheet extends StatelessWidget {
  const SubtaskDetailModalSheet({Key key, this.subtask, this.task})
      : super(key: key);
  final Subtask subtask;
  final Task task;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final model = ScopedModel.of<MainModel>(context);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(width * SizeRatio.spacingRatioWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${subtask.title}",
                    style: TextStyle(
                      fontSize: width * SizeRatio.heading2RatioWidth,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
                  Column(
                    children: <Widget>[
                      !subtask.isCompleted &&
                              subtask.to.isBefore(DateTime.now())
                          ? Tag(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    width * SizeRatio.paddingRatioWidth * 0.2,
                                horizontal:
                                    width * SizeRatio.paddingRatioWidth * 0.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                width * SizeRatio.paddingRatioWidth * 0.2,
                              ),
                              width: width,
                              backgroundColor: Colors.red,
                              text: Text(
                                "DUE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width *
                                      SizeRatio.subheading4RatioWidth *
                                      0.8,
                                ),
                              ),
                            )
                          : Container(
                              width: 0,
                            ),
                      subtask.from.isBefore(DateTime.now()) &&
                              subtask.to.isAfter(DateTime.now())
                          ? Tag(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      width * SizeRatio.paddingRatioWidth * 0.2,
                                  horizontal: width *
                                      SizeRatio.paddingRatioWidth *
                                      0.5),
                              borderRadius: BorderRadius.circular(
                                  width * SizeRatio.paddingRatioWidth * 0.2),
                              width: width,
                              backgroundColor: task.taskColor,
                              text: Text(
                                "ONGOING",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: width *
                                      SizeRatio.subheading4RatioWidth *
                                      0.8,
                                ),
                              ),
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            )
                    ],
                  ),
                  SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "${DateString.dynamicTime(subtask.from)} - ${DateString.dynamicTime(subtask.to)}",
                          style: TextStyle(
                            fontSize: width * SizeRatio.subheading4RatioWidth,
                            fontWeight: FontWeight.bold,
                            color: CustomColor.primarySubheadingTextColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: subtask.subtaskColor.withAlpha(10),
                            borderRadius: BorderRadius.circular(
                                width * SizeRatio.borderRadiusRatioWidth)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: width * SizeRatio.iconSize4RatioWidth,
                              color: subtask.subtaskColor,
                            ),
                            SizedBox(
                                width:
                                    width * SizeRatio.spacingRatioWidth * 0.2),
                            Text(
                              "${subtask.from.difference(subtask.to).abs().inHours} HOURS",
                              style: TextStyle(
                                fontSize:
                                    width * SizeRatio.subheading4RatioWidth,
                                color: subtask.subtaskColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: width * SizeRatio.spacingRatioWidth),
                ],
              ),
            ),
            Divider(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomFlatButton(
                  minWidth: width * 0.5,
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                      color: subtask.subtaskColor,
                      fontWeight: FontWeight.w700,
                      fontSize: width * SizeRatio.subheading4RatioWidth,
                    ),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: subtask.subtaskColor.withAlpha(10),
                  onPressed: () async {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      elevation: 3,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: SubtaskAdderModalSheet(
                            subtask: subtask,
                            task: task,
                            isEditMode: true,
                          ),
                        );
                      },
                    );
                  },
                ),
                CustomFlatButton(
                  minWidth: width * 0.5,
                  child: Text(
                    "DELETE",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: width * SizeRatio.subheading4RatioWidth,
                    ),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.red.withAlpha(10),
                  onPressed: () async {
                    await model.deleteSubtask(task, subtask.id);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//
