import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/subtask.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/subtask_details_modal_sheet.dart';
import 'package:first_team_project/ui/helper_widget/tag.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'oval_checkbox.dart';

class SubtaskTile extends StatelessWidget {
  const SubtaskTile(
      {Key key,
      this.scaffoldKey,
      @required this.context,
      @required this.task,
      @required this.subtask,
      @required this.width,
      @required this.height,
      this.isSubtaskIsNow})
      : super(key: key);

  final BuildContext context;
  final Task task;
  final Subtask subtask;
  final double width;
  final double height;
  final bool isSubtaskIsNow;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<MainModel>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      clipBehavior: Clip.antiAlias,
      child: CustomFlatButton(
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () async {
          if (subtask.from.isAfter(DateTime.now()))
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                    textColor: Colors.white,
                    label: "CLOSE",
                    onPressed: () {
                      scaffoldKey.currentState.removeCurrentSnackBar();
                    }),
                content: Text(
                  "Subtask is not started yet",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Quicksand',
                      fontSize: width * SizeRatio.subheading4RatioWidth),
                ),
              ),
            );
          else {
            await model.updateSubtask(
                task,
                Subtask(
                    id: subtask.id,
                    from: subtask.from,
                    to: subtask.to,
                    title: subtask.title,
                    isCompleted: !subtask.isCompleted,
                    subtaskColor: task.taskColor,
                    completionTime: !subtask.isCompleted ? DateTime.now() : subtask.from),
                subtask.id);
          }
        },
        onLongPress: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(width * SizeRatio.borderRadiusRatioWidth),
                topRight:
                    Radius.circular(width * SizeRatio.borderRadiusRatioWidth),
              ),
            ),
            elevation: 3,
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SubtaskDetailModalSheet(
                  subtask: subtask,
                  task: task,
                ),
              );
            },
          );
        },
        child: Container(
          margin: EdgeInsets.all(width * SizeRatio.paddingRatioWidth),
          decoration: BoxDecoration(
            color: isSubtaskIsNow ? Colors.white : Colors.white,
            borderRadius: BorderRadius.circular(
                width * SizeRatio.paddingRatioWidth * 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 5,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: ListTile(
                title: Text(
                  subtask.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: !subtask.isCompleted
                        ? CustomColor.primaryTextColor
                        : CustomColor.primarySubheadingTextColor,
                  ),
                ),
                subtitle: Text(
                  "${DateString.dynamicTime(subtask.from)}",
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: width * SizeRatio.subheading4RatioWidth * 0.8,
                    color: !subtask.isCompleted
                        ? CustomColor.primaryTextColor
                        : CustomColor.primarySubheadingTextColor,
                  ),
                ),
                leading: OvalCheckbox(
                  width: width,
                  initialValue: subtask.isCompleted,
                  iconColor: subtask.subtaskColor,
                  onChecked: () async {
                    if (subtask.from.isAfter(DateTime.now()))
                      scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                              textColor: Colors.white,
                              label: "CLOSE",
                              onPressed: () {
                                scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                              }),
                          content: Text(
                            "Subtask is not started yet",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand'),
                          ),
                        ),
                      );
                    else
                      await model.updateSubtask(
                          task,
                          Subtask(
                              id: subtask.id,
                              from: subtask.from,
                              to: subtask.to,
                              title: subtask.title,
                              isCompleted: !subtask.isCompleted,
                              subtaskColor: task.taskColor,
                              completionTime: !subtask.isCompleted ? DateTime.now() : subtask.from),
                          subtask.id);
                  },
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    !subtask.isCompleted && subtask.to.isBefore(DateTime.now())
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
                    isSubtaskIsNow
                        ? Tag(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    width * SizeRatio.paddingRatioWidth * 0.2,
                                horizontal:
                                    width * SizeRatio.paddingRatioWidth * 0.5),
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
                )),
          ),
        ),
      ),
    );
  }
}
