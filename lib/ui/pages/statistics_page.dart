import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/ui/helper_widget/custom_flat_button.dart';
import 'package:first_team_project/ui/util/CustomColors.dart';
import 'package:first_team_project/ui/util/SizeRatio.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final model = ScopedModel.of<MainModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildRow(width, model),
                SizedBox(height: width * SizeRatio.spacingRatioWidth),
                Row(
                  children: <Widget>[
                    buildAverageTimeSpend(
                        Colors.purple,
                        model.averageTimeTasks,
                        "Average Completion \nDuration of Task",
                        width),
                    buildAverageTimeSpend(
                        Colors.pink,
                        model.averageTimeSubtasks,
                        "Average Completion \nDuration of Subtask",
                        width),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(width * SizeRatio.spacingRatioWidth),
                  child: _buildStats(model, width),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRow(double width, MainModel model) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildUpperCounter(Colors.green, "Tasks", model.totalTasks, width),
        _buildUpperCounter(Colors.blue, "Subtasks", model.totalSubtasks, width),
        _buildUpperCounter(
            Colors.orange, "Ongoing\nTasks", model.totalRunningTasks, width)
      ],
    );
  }

  Widget _buildUpperCounter(
      Color color, String footerText, int data, double width) {
    return Container(
      width: width / 3,
      height: width * 0.35,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "$data",
            style: TextStyle(
              fontSize: width * SizeRatio.heading0RatioWidth * 2.2,
              color: Colors.white,
            ),
          ),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * SizeRatio.subheading4RatioWidth,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStats(MainModel model, double width) {
    return Column(
      children: <Widget>[
        _statCounter(width, Colors.green, model.totalCompletedTasks,
            model.totalTasks, "Completed Tasks"),
        _statCounter(width, Colors.red, model.totalFailedTasks,
            model.totalTasks, "Failed Tasks"),
        _statCounter(width, Colors.blue, model.totalUpcomingTasks,
            model.totalTasks, "Upcoming Tasks"),
        _statCounter(width, Colors.orange, model.totalCompletedSubtasks,
            model.totalSubtasks, "Completed Subtasks"),
        _statCounter(width, Colors.amber, model.totalSubtasksDue,
            model.totalSubtasks, "Subtasks Due"),
        _statCounter(width, Colors.lime, model.totalSubtaskCompletedWeek,
            model.totalSubtasks, "Completed Subtasks This Week")
      ],
    );
  }

  Widget _statCounter(
      double width, Color color, int current, int total, String footerText) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "${(current)}",
                style: TextStyle(
                  fontSize: width * SizeRatio.subheading3RatioWidth,
                  color: CustomColor.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: width * SizeRatio.spacingRatioWidth * 0.2,
              ),
              Text(
                "$footerText",
                style: TextStyle(
                    fontSize: width * SizeRatio.subheading3RatioWidth,
                    color: CustomColor.primaryTextColor),
              ),
            ],
          ),
          SizedBox(
            height: width * SizeRatio.spacingRatioWidth * 0.2,
          ),
          LinearPercentIndicator(
            percent: current / total,
            backgroundColor: color.withAlpha(10),
            progressColor: color,
            animation: true,
            animateFromLastPercent: true,
            center: Text(
              "$current",
              style: TextStyle(
                  fontSize: width * SizeRatio.subheading1RatioWidth,
                  color: CustomColor.primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: width * SizeRatio.spacingRatioWidth,
          )
        ],
      ),
    );
  }

  Widget buildAverageTimeSpend(
      Color color, Duration averageTime, String footerText, double width) {
    return Container(
      width: width * 0.5,
      padding: EdgeInsets.all(width * SizeRatio.paddingRatioWidth * 0.8),
      color: color.withAlpha(10),
      child: Column(
        children: <Widget>[
          Text(
            "${averageTime.inHours.toString().padLeft(2, '0')}:${(averageTime.inMinutes % 60).toString().padLeft(2, '0')}",
            style: TextStyle(
              fontSize: width * SizeRatio.heading2RatioWidth,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(
            height: width * SizeRatio.spacingRatioWidth * 0.4,
          ),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * SizeRatio.subheading4RatioWidth,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        child: Row(
          children: <Widget>[
            CustomFlatButton(
              shape: CircleBorder(),
              minWidth: 20,
              padding: EdgeInsets.all(width * SizeRatio.paddingRatioWidth),
              highlightColor: CustomColor.primaryIconColor.withAlpha(10),
              splashColor: Colors.transparent,
              child: Icon(
                Icons.arrow_back_ios,
                color: CustomColor.primaryIconColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: width * 0.06,),
            Text("Statistics", style: TextStyle(fontSize: width * SizeRatio.heading2RatioWidth),)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
