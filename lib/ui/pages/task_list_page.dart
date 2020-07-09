import 'package:first_team_project/core/models/main_model.dart';
import 'package:first_team_project/ui/helper_widget/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../util/CustomColors.dart';
import '../util/SizeRatio.dart';

class TaskListPage extends StatefulWidget {
  final String title;

  TaskListPage({Key key, this.title}) : super(key: key);

  @override
  TaskListPageState createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: CustomColor.primaryIconColor,
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: CustomColor.primaryTextColor,
              fontSize: width * SizeRatio.heading2RatioWidth),
        ),
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return Container(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: model.tasks.length,
            itemBuilder: (_, index) {
              return TaskTile(
                task: model.tasks[index],
              );
            },
          ));
        },
      ),
    );
  }
}
