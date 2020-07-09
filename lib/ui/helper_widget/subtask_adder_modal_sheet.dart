import 'dart:math';
import 'dart:wasm';

import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/subtask.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/time_picker.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:first_team_project/ui/helper_widget/number_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import 'date_picker.dart';

class SubtaskAdderModalSheet extends StatefulWidget {
  SubtaskAdderModalSheet(
      {Key key,
      this.height,
      this.task,
      this.subtask,
      this.isEditMode = false,
      this.scaffoldKey})
      : super(key: key);
  final double height;
  final Task task;
  final Subtask subtask;
  final bool isEditMode;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _SubtaskAdderModalSheetState createState() => _SubtaskAdderModalSheetState();
}

class _SubtaskAdderModalSheetState extends State<SubtaskAdderModalSheet> {
  DateTime fromDate;
  TimeOfDay fromTime;
  DateTime toDate;
  TimeOfDay toTime;
  int startMinutes;
  int startHours;
  int endMinutes;
  int endHours;
  TextEditingController _titleController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.subtask != null) {
      _titleController.text = widget.subtask.title;
      fromDate = DateTime(widget.subtask.from.year, widget.subtask.from.month,
          widget.subtask.from.day);
      fromTime = TimeOfDay.fromDateTime(widget.subtask.from);
      toDate = DateTime(widget.subtask.to.year, widget.subtask.to.month,
          widget.subtask.to.day);
      toTime = TimeOfDay.fromDateTime(widget.subtask.to);
      startMinutes = widget.subtask.notifyBeforeStart == null
          ? 5
          : widget.subtask.from
              .difference(widget.subtask.notifyBeforeStart)
              .abs()
              .inMinutes;
      startHours = widget.subtask.notifyBeforeStart == null
          ? 0
          : widget.subtask.from
              .difference(widget.subtask.notifyBeforeStart)
              .abs()
              .inHours;
      endMinutes = widget.subtask.notifyBeforeEnd == null
          ? 5
          : widget.subtask.to
              .difference(widget.subtask.notifyBeforeEnd)
              .abs()
              .inMinutes;
      endHours = widget.subtask.notifyBeforeEnd == null
          ? 0
          : widget.subtask.to
              .difference(widget.subtask.notifyBeforeEnd)
              .abs()
              .inHours;
    } else {
      fromDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      fromTime = TimeOfDay.fromDateTime(fromDate);
      toDate = fromDate.add(Duration(days: 1));
      toTime = TimeOfDay.fromDateTime(toDate);
      startMinutes = 5;
      startHours = 0;
      endMinutes = 5;
      endHours = 0;
    }
  }

  Future<void> showNotificationOnDateTime(
      {DateTime onTime, int id, String message, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'subtask_channel', 'subtasks', 'only for subtask notification',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    MainModel().flutterLocalNotificationsPlugin.schedule(
        id, _titleController.text, message, onTime, platformChannelSpecifics,
        payload: payload);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final model = ScopedModel.of<MainModel>(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTextField(width),
          SizedBox(height: width * SizeRatio.spacingRatioWidth * 1.2),
          Padding(
            padding: EdgeInsets.only(
              left: width * SizeRatio.spacingRatioWidth * 0.6,
              right: width * SizeRatio.spacingRatioWidth * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildFromRow(width),
                    _buildToRow(width),
                  ],
                ),
                SizedBox(height: width * SizeRatio.spacingRatioWidth),
                _buildNotifyBeforeStartRow(width, context),
                SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.6),
                _buildNotifyBeforeEndRow(width, context)
              ],
            ),
          ),
          Divider(height: 0),
          _buildCreateButton(width, context, model)
        ],
      ),
    );
  }

  Padding _buildTextField(double width) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * SizeRatio.spacingRatioWidth * 0.6,
          right: width * SizeRatio.spacingRatioWidth * 0.6,
          top: width * SizeRatio.spacingRatioWidth * 0.6),
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          autofocus: true,
          style: TextStyle(
            fontSize: width * SizeRatio.heading2RatioWidth,
            fontWeight: FontWeight.bold,
            color: CustomColor.primaryTextColor,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8.0),
            hintText: "Create Subtask",
            hintStyle: TextStyle(
                color: CustomColor.primarySubheadingTextColor,
                fontSize: width * SizeRatio.heading2RatioWidth),
            border: InputBorder.none,
          ),
          validator: (text) {
            if (text.length == 0) return "Title must be given";
            return null;
          },
        ),
      ),
    );
  }

  Row _buildFromRow(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "FROM",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * SizeRatio.subheading4RatioWidth,
              color: CustomColor.primaryTextColor),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DatePicker(
              date: fromDate,
              color: widget.task.taskColor,
              width: width,
              onDateChanged: (date) {
                setState(() {
                  fromDate = date;
                });
              },
            ),
            SizedBox(width: width * SizeRatio.spacingRatioWidth),
            TimePicker(
              color: widget.task.taskColor,
              initialTime: fromTime,
              width: width,
              onTimeChanged: (time) {
                setState(() {
                  fromTime = time;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Row _buildToRow(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "TO",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width * SizeRatio.subheading4RatioWidth,
              color: CustomColor.primaryTextColor),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DatePicker(
              date: toDate,
              color: widget.task.taskColor,
              width: width,
              onDateChanged: (date) {
                setState(() {
                  toDate = date;
                });
              },
            ),
            SizedBox(width: width * SizeRatio.spacingRatioWidth),
            TimePicker(
              color: widget.task.taskColor,
              initialTime: toTime,
              width: width,
              onTimeChanged: (time) {
                setState(() {
                  toTime = time;
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Row _buildNotifyBeforeStartRow(double width, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "NOTIFY BEFORE\nSTART",
          style: TextStyle(
            fontSize: width * SizeRatio.subheading4RatioWidth,
            color: CustomColor.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: <Widget>[
            NumberPicker(
              step: 1,
              task: widget.task,
              title: "Hours",
              initialValue: startHours.toDouble(),
              minValue: 0,
              maxValue: 12,
              onChanged: (hour) {
                setState(() {
                  startHours = hour.toInt() ?? startHours;
                });
              },
            ),
            Text(
              "HOURS",
              style: TextStyle(
                fontSize: width * SizeRatio.subheading4RatioWidth,
              ),
            ),
            NumberPicker(
              step: 5,
              task: widget.task,
              title: "Minutes",
              initialValue: startMinutes.toDouble(),
              minValue: 5,
              maxValue: 60,
              onChanged: (minute) {
                setState(() {
                  startMinutes = minute.toInt() ?? startMinutes;
                });
              },
            ),
            Text(
              "MINUTES",
              style: TextStyle(
                fontSize: width * SizeRatio.subheading4RatioWidth,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildNotifyBeforeEndRow(double width, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "NOTIFY BEFORE\nEND",
          style: TextStyle(
            fontSize: width * SizeRatio.subheading4RatioWidth,
            color: CustomColor.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: <Widget>[
            NumberPicker(
                step: 1,
                task: widget.task,
                title: "Hours",
                initialValue: endHours.toDouble(),
                minValue: 0,
                maxValue: 12,
                onChanged: (hour) {
                  setState(() {
                    endHours = hour.toInt() ?? endHours;
                  });
                }),
            Text(
              "HOURS",
              style:
                  TextStyle(fontSize: width * SizeRatio.subheading4RatioWidth),
            ),
            NumberPicker(
                step: 5,
                task: widget.task,
                title: "Minutes",
                initialValue: endMinutes.toDouble(),
                minValue: 5,
                maxValue: 60,
                onChanged: (minute) {
                  setState(() {
                    endMinutes = minute.toInt() ?? endMinutes;
                  });
                }),
            Text(
              "MINUTES",
              style:
                  TextStyle(fontSize: width * SizeRatio.subheading4RatioWidth),
            ),
          ],
        ),
      ],
    );
  }

  CustomFlatButton _buildCreateButton(
      double width, BuildContext context, MainModel model) {
    return CustomFlatButton(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth),
      ),
      child: Text(
        widget.isEditMode ? "SAVE" : "CREATE",
        style: TextStyle(
          color: widget.task.taskColor,
          fontWeight: FontWeight.w700,
          fontSize: width * SizeRatio.subheading3RatioWidth,
        ),
      ),
      minWidth: double.infinity,
      height: width * 0.1,
      splashColor: Colors.transparent,
      highlightColor: widget.task.taskColor.withAlpha(10),
      highlightElevation: 0,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          if (toDate
              .add(
                Duration(
                  hours: toTime.hour,
                  minutes: toTime.minute,
                ),
              )
              .isBefore(
                fromDate.add(
                  Duration(
                    hours: fromTime.hour,
                    minutes: fromTime.minute,
                  ),
                ),
              )) {
            widget.scaffoldKey.currentState.showSnackBar(
              SnackBar(
                action: SnackBarAction(
                    textColor: Colors.white,
                    label: "CLOSE",
                    onPressed: () {
                      widget.scaffoldKey.currentState.removeCurrentSnackBar();
                    }),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Ending date should be after Starting date",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * SizeRatio.subheading4RatioWidth,
                  ),
                ),
              ),
            );
            Navigator.pop(context);
          } else {
            var from = fromDate
                .add(Duration(hours: fromTime.hour, minutes: fromTime.minute));
            var to = toDate
                .add(Duration(hours: toTime.hour, minutes: toTime.minute));
            var notifyBeforeStart = from
                .subtract(Duration(hours: startHours, minutes: startMinutes));
            var notifyBeforeEnd =
                to.subtract(Duration(hours: endHours, minutes: endMinutes));

            var subtask = Subtask(
                title: _titleController.text,
                from: from,
                to: to,
                subtaskColor: widget.task.taskColor,
                isCompleted:
                    widget.isEditMode ? widget.subtask.isCompleted : false,
                notifyBeforeStart: notifyBeforeStart,
                notifyBeforeEnd: notifyBeforeEnd);

            if (!widget.isEditMode) {
              subtask.notificationId = subtask.hashCode;
              await model.addSubtask(widget.task, subtask);
            } else {
              subtask.notificationId = widget.subtask.notificationId;
              print(widget.subtask.notificationId);
              await model.updateSubtask(
                  widget.task, subtask, widget.subtask.id);
            }

            // cancelling all the previous registered notification of this subtask
            if (widget.subtask == null || subtask.notifyBeforeStart != widget.subtask.notifyBeforeStart)
              await MainModel()
                  .flutterLocalNotificationsPlugin
                  .cancel(subtask.notificationId);

            if (widget.subtask == null || subtask.notifyBeforeEnd != widget.subtask.notifyBeforeEnd)
              await MainModel()
                  .flutterLocalNotificationsPlugin
                  .cancel(subtask.notificationId + 1);

            if (widget.subtask == null || subtask.from != widget.subtask.from)
              await MainModel()
                  .flutterLocalNotificationsPlugin
                  .cancel(subtask.notificationId + 2);

            if (subtask.notifyBeforeStart.isAfter(DateTime.now()))
              await showNotificationOnDateTime(
                onTime: subtask.notifyBeforeStart,
                id: subtask.notificationId,
                message:
                    "STARTS IN ${startHours.toString().padLeft(2, '0')}:${startMinutes.toString().padLeft(2, '0')}",
                payload: "${widget.task.id}-${subtask.id}",
              );

            if (subtask.notifyBeforeEnd.isAfter(DateTime.now()))
              await showNotificationOnDateTime(
                onTime: subtask.notifyBeforeEnd,
                id: subtask.notificationId + 1,
                message:
                    "ENDS IN ${endHours.toString().padLeft(2, '0')}:${endMinutes.toString().padLeft(2, '0')}",
                payload: "${widget.task.id}-${subtask.id}",
              );

            if (subtask.from.isAfter(DateTime.now()))
              await showNotificationOnDateTime(
                  onTime: subtask.from,
                  id: subtask.notificationId + 2,
                  message: "STARTS NOW",
                  payload: "${widget.task.id}-${subtask.id}");

            widget.task.isCompleted = false;
            await model.updateTask(widget.task);

            Navigator.pop(context);
          }
        }
      },
    );
  }
}
