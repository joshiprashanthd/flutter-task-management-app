import 'package:first_team_project/core/helper/datetime_helper.dart';
import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/helper_widget/sutbask_tile.dart';
import 'package:first_team_project/ui/helper_widget/task_adder_modal_sheet.dart';
import 'package:first_team_project/ui/helper_widget/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/CustomColors.dart';
import '../util/SizeRatio.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  DateTime currentDateSelected;
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey;

  AnimationController _controller;
  Animation<double> _fadeAnimation;

  @override
  void initState() {
    currentDateSelected = DateTime.now();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _controller.forward();

    MainModel().initializeNotification();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final headerHeight = height * 0.22;
    final bodyHeight = height * (1 - (headerHeight / height));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: TaskAddButton(
          scaffoldKey: _scaffoldKey,
          context: context,
          width: width,
          height: height),
      bottomSheet: _buildBottomAppBar(width, context),
      body: SafeArea(
        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 16.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildHeader(context, width, headerHeight),
                SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.6),
                AnimatedBuilder(
                  animation: _controller,
                  child: _buildBody(bodyHeight, width, height),
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                ),
                Container(height: kBottomNavigationBarHeight * 1.6)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ScopedModelDescendant<MainModel> _buildBody(
      double bodyHeight, double width, double height) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        final tasks = model.allTasksOnDate(currentDateSelected);
        return tasks.length == 0
            ? Container(
                height: bodyHeight * 0.7,
                child: Center(
                  child:
                      Text("No tasks today. Add task to be more productive."),
                ),
              )
            : Column(
                children: model.tasks.map(
                  (task) {
                    return TaskBody(
                      scaffoldKey: _scaffoldKey,
                      currentDateSelected: currentDateSelected,
                      context: context,
                      task: task,
                      bodyHeight: bodyHeight,
                      model: model,
                      width: width,
                      height: height,
                    );
                  },
                ).toList(),
              );
      },
    );
  }

  BottomAppBar _buildBottomAppBar(double width, BuildContext context) {
    return BottomAppBar(
      elevation: 6,
      notchMargin: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chartBar,
                size: width * SizeRatio.iconSize1RatioWidth,
                color: CustomColor.primaryIconColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/statistics_page');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: width * SizeRatio.iconSize1RatioWidth,
                color: CustomColor.primaryIconColor,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Column _buildHeader(BuildContext context, double width, double headerHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: width * SizeRatio.spacingRatioWidth * 1.8),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          child: Text(
            "${DateFormat("EEE, MMM d, y").format(DateTime.now())}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryTextColor),
          ),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, width * 0.1 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
        ),
        SizedBox(height: width * SizeRatio.spacingRatioWidth * 0.5),
        Text(
          "Today's Tasks",
          style: TextStyle(
              fontSize: width * SizeRatio.heading1RatioWidth,
              color: CustomColor.primaryTextColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: width * SizeRatio.spacingRatioWidth),
        SizedBox(
          height: headerHeight * 0.4,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              7,
              (index) {
                var startDayOfWeek = DateTimeHelper.firstDateOfWeek;
                var buttonDate = startDayOfWeek.add(Duration(days: index));
                return TweenAnimationBuilder(
                  tween: Tween<double>(
                      begin: 0,
                      end: currentDateSelected.day == buttonDate.day
                          ? 1.2
                          : 1.0),
                  duration: const Duration(milliseconds: 100),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${DateFormat('EEEE').format(buttonDate).substring(0, 3).toUpperCase()}",
                        style: TextStyle(
                            fontWeight:
                                currentDateSelected.day == buttonDate.day
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: width * SizeRatio.subheading4RatioWidth),
                      ),
                      CustomFlatButton(
                        shape: CircleBorder(),
                        minWidth: width * 0.08,
                        padding: EdgeInsets.zero,
                        color: currentDateSelected.day == buttonDate.day
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.1),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.blue.withOpacity(0.1),
                        highlightElevation: 0,
                        child: Center(
                          child: Text(
                            "${buttonDate.day}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: currentDateSelected.day == buttonDate.day
                                    ? Colors.white
                                    : Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    width * SizeRatio.subheading4RatioWidth),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentDateSelected = buttonDate;
                            _controller.reset();
                            _controller.forward();
                          });
                        },
                      ),
                    ],
                  ),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class TaskAddButton extends StatelessWidget {
  const TaskAddButton({
    Key key,
    this.scaffoldKey,
    @required this.context,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final BuildContext context;
  final double width;
  final double height;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return CustomFlatButton(
      shape: CircleBorder(),
      height: height * 0.08,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      highlightElevation: 2,
      color: Colors.blue,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () {
        showModalBottomSheet(
          elevation: 3,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(width * SizeRatio.borderRadiusRatioWidth),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                  width * SizeRatio.borderRadiusRatioWidth),
              child: TaskAdderModalSheet(
                scaffoldKey: scaffoldKey,
                height: height,
                isEditMode: false,
              ),
            ),
          ),
        );
      },
    );
  }
}

class TaskBody extends StatelessWidget {
  const TaskBody({
    Key key,
    this.scaffoldKey,
    @required this.currentDateSelected,
    @required this.context,
    @required this.task,
    @required this.bodyHeight,
    @required this.model,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  final DateTime currentDateSelected;
  final BuildContext context;
  final Task task;
  final double bodyHeight;
  final MainModel model;
  final double width;
  final double height;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return task.subtaskCompleted == task.totalSubtasks &&
            task.from.isBefore(currentDateSelected)
        ? TaskTile(task: task)
        : (model.allSubtasksOnDate(task, currentDateSelected).length == 0)
            ? TaskTile(task: task)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.7,
                        child: Text(
                          "${task.title}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: width * SizeRatio.heading2RatioWidth,
                            color: CustomColor.primaryTextColor,
                          ),
                        ),
                      ),
                      CustomFlatButton(
                        shape: CircleBorder(),
                        color: Colors.white,
                        splashColor: Colors.transparent,
                        highlightColor: task.taskColor.withAlpha(10),
                        highlightElevation: 0,
                        padding:
                            EdgeInsets.all(width * SizeRatio.paddingRatioWidth),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: task.taskColor,
                          size: width * SizeRatio.iconSize3RatioWidth,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/task_show_page',
                              arguments: task.id);
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: model
                        .allSubtasksOnDate(task, currentDateSelected)
                        .map(
                          (subtask) => SubtaskTile(
                            scaffoldKey: scaffoldKey,
                            task: task,
                            subtask: subtask,
                            context: context,
                            width: width,
                            height: height,
                            isSubtaskIsNow:
                                subtask.from.isBefore(DateTime.now()) &&
                                    DateTime.now().isBefore(subtask.to),
                          ),
                        )
                        .toList(),
                  ),
                  Divider(),
                ],
              );
  }
}
