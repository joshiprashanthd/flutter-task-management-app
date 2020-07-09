
import 'package:first_team_project/ui/pages/home_page.dart';
import 'package:first_team_project/ui/pages/statistics_page.dart';
import 'package:first_team_project/ui/pages/task_list_page.dart';
import 'package:first_team_project/ui/pages/task_show_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Router{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (context) => HomePage());
      case '/task_list_page':
        return MaterialPageRoute(builder: (context) => TaskListPage());
      case '/task_show_page':
        return MaterialPageRoute(builder: (context) => TaskShowPage(taskId: settings.arguments));
      case '/statistics_page':
        return MaterialPageRoute(builder: (context) => StatisticsPage());
    }
  }
}