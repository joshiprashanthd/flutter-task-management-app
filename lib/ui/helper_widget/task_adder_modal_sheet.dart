import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/date_picker.dart';
import 'package:first_team_project/ui/helper_widget/time_picker.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskAdderModalSheet extends StatefulWidget {
  TaskAdderModalSheet(
      {Key key, this.height, this.task, this.isEditMode, this.scaffoldKey})
      : super(key: key);

  final double height;
  final bool isEditMode;
  final Task task;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _TaskAdderModalSheetState createState() => _TaskAdderModalSheetState();
}

class _TaskAdderModalSheetState extends State<TaskAdderModalSheet> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  DateTime fromDate;
  TimeOfDay fromTime;
  DateTime toDate;
  TimeOfDay toTime;
  DateTime to;
  Color color;
  String description;
  bool addNote;

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task.title;
      _noteController.text = widget.task.description;
      fromDate = DateTime(
          widget.task.from.year, widget.task.from.month, widget.task.from.day);
      fromTime = TimeOfDay.fromDateTime(widget.task.from);
      toDate = DateTime(
          widget.task.to.year, widget.task.to.month, widget.task.to.day);
      toTime = TimeOfDay.fromDateTime(widget.task.to);
      color = widget.task.taskColor;
    } else {
      fromDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      fromTime = TimeOfDay.fromDateTime(fromDate);
      toDate = fromDate.add(Duration(days: 1));
      toTime = TimeOfDay.fromDateTime(toDate);
      color = Colors.blue;
    }

    addNote = _noteController.text.length > 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<MainModel>(context);
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
            Padding(
              padding: EdgeInsets.only(
                  left: width * SizeRatio.spacingRatioWidth * 0.6,
                  right: width * SizeRatio.spacingRatioWidth * 0.6,
                  top: width * SizeRatio.spacingRatioWidth * 0.6),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _titleController,
                  autofocus: !widget.isEditMode,
                  style: TextStyle(
                      color: CustomColor.primaryTextColor,
                      fontSize: width * SizeRatio.heading1RatioWidth,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLength: 100,
                  maxLines: 1,
                  minLines: 1,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8.0),
                    hintText: "I'm going to do....",
                    hintStyle: TextStyle(
                        color: CustomColor.primarySubheadingTextColor,
                        fontSize: width * SizeRatio.heading1RatioWidth,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (text) {
                    if (text.length == 0) return "Title must be given";
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: width * SizeRatio.spacingRatioWidth),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * SizeRatio.spacingRatioWidth * 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildFromRow(width),
                  _buildToRow(width),
                ],
              ),
            ),
            SizedBox(height: width * SizeRatio.spacingRatioWidth),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * SizeRatio.spacingRatioWidth * 0.6),
              child: _bulildDescriptionField(width),
            ),
            SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * SizeRatio.spacingRatioWidth * 0.6),
              child: _buildOption(
                width: width,
                icon: FontAwesomeIcons.palette,
                color: color,
                optionTitle: "Choose Color",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      Widget _buildColorOption(Color color) {
                        return GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              this.color = color;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }

                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Choose Color",
                                style: TextStyle(
                                  color: CustomColor.primaryTextColor,
                                  fontSize:
                                      width * SizeRatio.subheading2RatioWidth,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: width * SizeRatio.spacingRatioWidth,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                runSpacing: 16.0,
                                spacing: 16.0,
                                children: <Widget>[
                                  _buildColorOption(Colors.purple),
                                  _buildColorOption(Colors.blue),
                                  _buildColorOption(Colors.cyan),
                                  _buildColorOption(Color(0xff10b48e)),
                                  _buildColorOption(Colors.indigo),
                                  _buildColorOption(Colors.pink),
                                  _buildColorOption(Colors.deepOrange),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: width * SizeRatio.spacingRatioWidth),
            Divider(height: 0),
            _buildAddButton(model, width),
          ],
        ),
      ),
    );
  }

  Padding _buildToRow(double width) {
    return Padding(
      padding: EdgeInsets.only(left: width * SizeRatio.spacingRatioWidth * 0.6),
      child: Row(
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
                color: color,
                width: width,
                onDateChanged: (date) {
                  setState(() {
                    toDate = date;
                  });
                },
              ),
              SizedBox(width: width * SizeRatio.spacingRatioWidth),
              TimePicker(
                color: color,
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
      ),
    );
  }

  Padding _buildFromRow(double width) {
    return Padding(
      padding: EdgeInsets.only(left: width * SizeRatio.spacingRatioWidth * 0.6),
      child: Row(
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
                color: color,
                width: width,
                onDateChanged: (date) {
                  setState(() {
                    fromDate = date;
                  });
                },
              ),
              SizedBox(width: width * SizeRatio.spacingRatioWidth),
              TimePicker(
                color: color,
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
      ),
    );
  }

  Padding _bulildDescriptionField(double width) {
    return Padding(
      padding: EdgeInsets.only(left: width * SizeRatio.paddingRatioWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Why'd you wanna do this?",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryTextColor,
                fontSize: width * SizeRatio.subheading3RatioWidth),
          ),
          Form(
            key: _formKey2,
            child: TextFormField(
              controller: _noteController,
              autofocus: !widget.isEditMode,
              style:
                  TextStyle(fontSize: width * SizeRatio.subheading3RatioWidth),
              minLines: 1,
              maxLines: 3,
              maxLength: 150,
              enableSuggestions: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                errorMaxLines: 2,
                errorStyle: TextStyle(color: color),
                counterText: "",
                hintText: "Clear your why",
                hintStyle: TextStyle(
                    color: CustomColor.primarySubheadingTextColor,
                    fontSize: width * SizeRatio.subheading3RatioWidth),
                border: InputBorder.none,
              ),
              validator: (text) {
                if (text.length == 0)
                  return "Clear objectives increases the odds of completing the task";
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  CustomFlatButton _buildOption(
      {IconData icon,
      Color color,
      String optionTitle,
      double width,
      void Function() onPressed}) {
    return CustomFlatButton(
      minWidth: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: color ?? CustomColor.primaryIconColor,
            size: width * SizeRatio.iconSize3RatioWidth,
          ),
          SizedBox(
            width: width * SizeRatio.spacingRatioWidth * 0.5,
          ),
          Text(
            optionTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryTextColor,
                fontSize: width * SizeRatio.subheading3RatioWidth),
          ),
        ],
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onPressed: onPressed,
    );
  }

  CustomFlatButton _buildAddButton(MainModel model, double width) {
    return CustomFlatButton(
      child: Text(
        widget.isEditMode ? "SAVE" : "CREATE",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: width * SizeRatio.subheading3RatioWidth,
        ),
      ),
      minWidth: double.infinity,
      height: width * 0.1,
      splashColor: Colors.transparent,
      highlightColor: color.withAlpha(10),
      highlightElevation: 0,
      onPressed: () async {
        if (_formKey.currentState.validate() &&
            _formKey2.currentState.validate()) {
          var to =
              toDate.add(Duration(hours: toTime.hour, minutes: toTime.minute));
          var from = fromDate
              .add(Duration(hours: fromTime.hour, minutes: fromTime.minute));

          if (to.isBefore(from)) {
            widget.scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("To is before from"),
              action: SnackBarAction(
                  label: "CLOSE",
                  onPressed: () {
                    widget.scaffoldKey.currentState.removeCurrentSnackBar();
                  }),
            ));
          } else {
            if (!widget.isEditMode) {
              await model.addTask(
                Task(
                  title: _titleController.text,
                  description: _noteController.text,
                  taskColor: color,
                  from: from,
                  to: to,
                  subtasks: [],
                ),
              );
            } else {
              widget.task.title = _titleController.text;
              widget.task.description = _noteController.text;
              widget.task.from = fromDate.add(
                  Duration(hours: fromTime.hour, minutes: fromTime.minute));
              widget.task.to = toDate
                  .add(Duration(hours: toTime.hour, minutes: toTime.minute));
              widget.task.taskColor = color;

              await model.updateTask(widget.task);
            }
          }

          Navigator.pop(context);
        }
      },
    );
  }
}
