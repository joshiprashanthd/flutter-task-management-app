import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/core/storage/db_helper.dart';
import 'package:first_team_project/locator.dart';

class TaskStorage {
  List<Task> _tasks = [];
  List<int> _todayTaskIds = [];
  List<int> _upcomingTaskIds = [];

  DBHelper dbhelper = locator<DBHelper>();

  TaskStorage() {}

  Future<void> refreshTaskList() async {
    this._tasks = await dbhelper.fetchAllTasks();
    this._todayTaskIds = [];
    this._upcomingTaskIds = [];

    for(final task in _tasks){
      if(DateTime.now().difference(task.from).inHours < 24)
        this._todayTaskIds.add(task.id);
    }

    for(final task in _tasks){
      if(!this._todayTaskIds.contains(task.id))
        this._upcomingTaskIds.add(task.id);
    }
  }

  List<Task> get tasks => List.from(_tasks);
  List<int> get todayTaskIds => List.from(_todayTaskIds);
  List<int> get upcomingTaskIds => List.from(_upcomingTaskIds);
}
