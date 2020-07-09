import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/locator.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/subtask_adder_modal_sheet.dart';
import 'package:first_team_project/ui/helper_widget/sutbask_tile.dart';
import 'package:first_team_project/ui/helper_widget/tag.dart';
import 'package:first_team_project/ui/helper_widget/task_adder_modal_sheet.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/DateString.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskShowPage extends StatefulWidget {
  TaskShowPage({Key key, this.taskId})
      : assert(taskId != null),
        super(key: key);

  final int taskId;

  @override
  _TaskShowPageState createState() => _TaskShowPageState();
}

class _TaskShowPageState extends State<TaskShowPage>
    with SingleTickerProviderStateMixin {
  Task task;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    task = locator<MainModel>().fetchTaskWithId(widget.taskId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.ease,
        child: AddSubtaskFAB(
            task: task,
            width: width,
            height: height,
            scaffoldKey: _scaffoldKey),
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          this.task = model.fetchTaskWithId(widget.taskId);
          return SafeArea(
            child: Stack(
              children: <Widget>[
                Body(
                    scaffoldKey: _scaffoldKey,
                    task: task,
                    height: height,
                    width: width),
                TweenAnimationBuilder(
                    tween: Tween<Offset>(
                        begin: Offset(0, -width), end: Offset(0, 0)),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.ease,
                    child: Header(
                        scaffoldKey: _scaffoldKey,
                        height: height,
                        task: task,
                        width: width),
                    builder: (context, offset, child) {
                      return Transform.translate(offset: offset, child: child);
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AddSubtaskFAB extends StatelessWidget {
  const AddSubtaskFAB({
    Key key,
    @required this.task,
    @required this.width,
    @required this.height,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final Task task;
  final double width;
  final double height;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return CustomFlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      elevation: 3.0,
      highlightElevation: 2,
      color: task.taskColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            Icon(Icons.add,
                color: Colors.white,
                size: width * SizeRatio.iconSize1RatioWidth),
            SizedBox(width: width * SizeRatio.spacingRatioWidth * 0.3),
            Text(
              "SUBTASK",
              style: TextStyle(
                fontSize: width * SizeRatio.subheading4RatioWidth,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
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
            var container = SubtaskAdderModalSheet(
              height: height,
              task: task,
              scaffoldKey: _scaffoldKey,
            );
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: container,
            );
          },
        );
      },
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.scaffoldKey,
    @required this.height,
    @required this.task,
    @required this.width,
  }) : super(key: key);

  final double height;
  final Task task;
  final double width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft:
              Radius.circular(width * SizeRatio.borderRadiusRatioWidth * 4),
          bottomRight:
              Radius.circular(width * SizeRatio.borderRadiusRatioWidth * 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (context, child, model){
              return _buildAppBar(context, model);
            },
          ),
          Padding(
            padding: EdgeInsets.all(width * SizeRatio.paddingRatioWidth * 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(),
                SizedBox(
                  height: width * SizeRatio.spacingRatioWidth * 0.35,
                ),
                _buildDescription(),
                SizedBox(
                  height: width * SizeRatio.spacingRatioWidth * 0.25,
                ),
                SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "${DateString.staticTime(task.from, onlyDate: true)}- ${DateString.staticTime(task.to, onlyDate: true)}",
                            style: TextStyle(
                              color: CustomColor.primarySubheadingTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: width * SizeRatio.spacingRatioWidth * 0.2),
                        Row(
                          children: <Widget>[
                            Tag(
                              width: width,
                              text: Text(
                                "${task.totalSubtasks} SUBTASKS",
                                style: TextStyle(
                                  color: task.taskColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: task.taskColor.withAlpha(10),
                            ),
                            SizedBox(
                                width:
                                    width * SizeRatio.spacingRatioWidth * 0.2),
                            Icon(
                              FontAwesomeIcons.solidCircle,
                              size: width * SizeRatio.iconSize4RatioWidth * 0.4,
                              color: CustomColor.primaryIconColor,
                            ),
                            SizedBox(
                                width:
                                    width * SizeRatio.spacingRatioWidth * 0.2),
                            Tag(
                              width: width,
                              text: Text(
                                "${task.from.difference(task.to).abs().inHours} HOURS",
                                style: TextStyle(
                                  color: task.taskColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: task.taskColor.withAlpha(10),
                            )
                          ],
                        ),
                      ],
                    ),
                    _buildProgressIndicator(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  CircularPercentIndicator _buildProgressIndicator() {
    return CircularPercentIndicator(
      progressColor: task.taskColor,
      radius: width * 0.17,
      animation: true,
      animateFromLastPercent: true,
      backgroundColor: task.taskColor.withAlpha(10),
      percent: task.totalSubtasks == 0
          ? 0
          : task.subtaskCompleted / task.totalSubtasks,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        task.totalSubtasks == 0
            ? "0 %"
            : "${(task.subtaskCompleted / task.totalSubtasks * 100).floor()} %",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: width * SizeRatio.subheading4RatioWidth,
          color: CustomColor.primaryTextColor,
        ),
      ),
    );
  }

  AutoSizeText _buildDescription() {
    return AutoSizeText(
      task.description.length <= 0 ? "" : "${task.description}",
      maxLines: 4,
      style: TextStyle(
        fontSize: width * SizeRatio.subheading3RatioWidth,
        color: CustomColor.primarySubheadingTextColor,
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      "${task.title}",
      style: TextStyle(
        fontSize: width * SizeRatio.heading1RatioWidth,
        color: CustomColor.primaryTextColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Row _buildAppBar(BuildContext context, MainModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildActionButton(
          icon: Icons.arrow_back_ios,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Row(
          children: <Widget>[
            _buildActionButton(
              icon: task.isCompleted ? Icons.check_circle : Icons.check,
              onPressed: task.isCompleted
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Mark As Not Done",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: <Widget>[
                            CustomFlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: task.taskColor.withAlpha(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    width * SizeRatio.borderRadiusRatioWidth),
                              ),
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  fontSize:
                                      width * SizeRatio.subheading4RatioWidth,
                                  fontWeight: FontWeight.bold,
                                  color: task.taskColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CustomFlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: task.taskColor.withAlpha(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    width * SizeRatio.borderRadiusRatioWidth),
                              ),
                              child: Text(
                                "YES",
                                style: TextStyle(
                                  fontSize:
                                      width * SizeRatio.subheading4RatioWidth,
                                  fontWeight: FontWeight.bold,
                                  color: task.taskColor,
                                ),
                              ),
                              onPressed: () async {
                                task.isCompleted = false;
                                await model.updateTask(task);
                              },
                            )
                          ],
                        ),
                      );
                    }
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              width * SizeRatio.borderRadiusRatioWidth,
                            ),
                          ),
                          title: Text(
                            "Mark As Done",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            task.totalSubtasks != task.subtaskCompleted
                                ? "It seems that you have ${task.totalSubtasks - task.subtaskCompleted} subtasks remaining to be done. First complete them."
                                : "You should be proud of yourself.",
                          ),
                          actions: <Widget>[
                            task.totalSubtasks == task.subtaskCompleted
                                ? CustomFlatButton(
                                    splashColor: Colors.transparent,
                                    highlightColor:
                                        task.taskColor.withAlpha(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          width *
                                              SizeRatio.borderRadiusRatioWidth),
                                    ),
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(
                                        fontSize: width *
                                            SizeRatio.subheading4RatioWidth,
                                        fontWeight: FontWeight.bold,
                                        color: task.taskColor,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : Container(),
                            CustomFlatButton(
                              splashColor: Colors.transparent,
                              highlightColor: task.taskColor.withAlpha(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    width * SizeRatio.borderRadiusRatioWidth),
                              ),
                              child: Text(
                                task.totalSubtasks == task.subtaskCompleted
                                    ? "YES!"
                                    : "OK",
                                style: TextStyle(
                                  fontSize:
                                      width * SizeRatio.subheading4RatioWidth,
                                  fontWeight: FontWeight.bold,
                                  color: task.taskColor,
                                ),
                              ),
                              onPressed: () async {
                                if (task.totalSubtasks ==
                                    task.subtaskCompleted) {
                                  task.isCompleted = true;
                                  task.completionTime = DateTime.now();
                                  await model.updateTask(task);
                                }
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
            ),
            _buildActionButton(
              icon: Icons.edit,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          width * SizeRatio.borderRadiusRatioWidth),
                      topRight: Radius.circular(
                          width * SizeRatio.borderRadiusRatioWidth),
                    ),
                  ),
                  elevation: 3,
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    var container = TaskAdderModalSheet(
                      scaffoldKey: scaffoldKey,
                      height: height,
                      task: task,
                      isEditMode: true,
                    );
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: container,
                    );
                  },
                );
              },
            ),
            _buildActionButton(
              icon: Icons.delete,
              onPressed: () async {
                bool isCanceled = false;
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        width * SizeRatio.borderRadiusRatioWidth,
                      ),
                    ),
                    title: Text(
                      "Are you sure?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      task.subtaskCompleted < task.totalSubtasks
                          ? "Deleting a task will not solve your problem. You still have ${task.totalSubtasks - task.subtaskCompleted} subtasks remaining."
                          : "It seems that you have completed all your subtasks. Keep it up.",
                    ),
                    actions: <Widget>[
                      CustomFlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: task.taskColor.withAlpha(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              width * SizeRatio.borderRadiusRatioWidth),
                        ),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              color: task.taskColor,
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  width * SizeRatio.subheading4RatioWidth),
                        ),
                        onPressed: () {
                          isCanceled = true;
                          Navigator.pop(context);
                        },
                      ),
                      CustomFlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              width * SizeRatio.borderRadiusRatioWidth),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.red.withAlpha(10),
                        child: Text(
                          "DELETE",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  width * SizeRatio.subheading4RatioWidth),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await MainModel().deleteTask(task);
                        },
                      )
                    ],
                  ),
                );
                if (!isCanceled) Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildActionButton({IconData icon, void Function() onPressed}) {
    return CustomFlatButton(
        shape: CircleBorder(),
        minWidth: 20,
        padding: EdgeInsets.all(width * SizeRatio.paddingRatioWidth),
        highlightColor: task.taskColor.withAlpha(10),
        splashColor: Colors.transparent,
        child: Icon(
          icon,
          color: task.taskColor,
        ),
        onPressed: onPressed);
  }
}

class Body extends StatelessWidget {
  const Body({
    Key key,
    this.scaffoldKey,
    @required this.task,
    @required this.height,
    @required this.width,
  }) : super(key: key);

  final Task task;
  final double height;
  final double width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: task.totalSubtasks > 0
          ? SizedBox(
              height: height,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: task.totalSubtasks + 1,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                        height: height * 0.4,
                      );
                    return TweenAnimationBuilder(
                      tween: Tween<Offset>(
                          begin: Offset(height * 0.5 + index * 0.2 * height, 0),
                          end: Offset(0, 0)),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.fastOutSlowIn,
                      builder: (context, offset, child) {
                        return Transform.translate(
                          offset: offset,
                          child: SubtaskTile(
                            scaffoldKey: scaffoldKey,
                            context: context,
                            task: task,
                            subtask: task.subtasks[index - 1],
                            width: width,
                            height: height,
                            isSubtaskIsNow: task.subtasks[index - 1].from
                                    .isBefore(DateTime.now()) &&
                                DateTime.now()
                                    .isBefore(task.subtasks[index - 1].to),
                          ),
                        );
                      },
                    );
                  }),
            )
          : Container(
              child: Center(
                child: Text(
                  "Add subtasks to be more productive",
                  style: TextStyle(
                    fontSize: SizeRatio.heading3RatioWidth * width,
                    color: CustomColor.primarySubheadingTextColor,
                  ),
                ),
              ),
            ),
    );
  }
}
