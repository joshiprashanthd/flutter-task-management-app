import 'package:first_team_project/core/enums/viewstate.dart';
import 'package:first_team_project/core/helper/datetime_helper.dart';
import 'package:first_team_project/core/helper/task_helper.dart';
import 'package:first_team_project/core/models/base_model.dart';
import 'package:first_team_project/core/models/subtask.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/core/storage/db_helper.dart';
import 'package:first_team_project/core/storage/task_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../locator.dart';

class MainModel extends BaseModel with TaskHelper {
  TaskStorage taskStorage = locator<TaskStorage>();
  DBHelper dbhelper = locator<DBHelper>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static MainModel _instance = new MainModel.internal();
  MainModel.internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }
  factory MainModel() => _instance;

  int totalTasks; //num
  int totalFailedTasks; //percent
  int totalUpcomingTasks; //num
  int totalCompletedTasks; //percent
  int totalSubtasks; //num
  int totalCompletedSubtasks; //percent
  int totalSubtaskCompletedWeek; //percent
  int totalSubtaskCompletedMonth; //percent
  int totalRunningTasks; //num
  int totalSubtasksDue;
  Duration averageTimeTasks;
  Duration averageTimeSubtasks;

  List<int> get todayTaskIds => taskStorage.todayTaskIds;
  List<Task> get tasks => taskStorage.tasks;
  List<int> get upcomingTaskIds => taskStorage.upcomingTaskIds;

  Future<void> initializeNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> addTask(Task task) async {
    await dbhelper.insertTask(task);
    await updateGlobalStats();
    setState(ViewState.IDLE);
  }

  Future<void> updateTask(Task task) async {
    this.updateTaskStats(task);
    await dbhelper.updateTask(task);
    await updateGlobalStats(task: task);
    setState(ViewState.IDLE);
  }

  Future<void> deleteTask(Task task) async {
    await dbhelper.deleteTask(task);
    await updateGlobalStats();
    setState(ViewState.IDLE);
  }

  Future<void> addSubtask(Task task, Subtask subtask) async {
    if (task.subtasks == null) task.subtasks = <Subtask>[];
    task.subtasks.add(subtask);
    task.to = getLastSubtaskToDo(task).to.isAfter(task.to)
        ? getLastSubtaskToDo(task).to
        : task.to;
    task.from = getFirstSubtaskToDo(task).from.isBefore(task.from)
        ? getFirstSubtaskToDo(task).from
        : task.from;
    this.updateTaskStats(task);
    await dbhelper.updateTask(task);
    await updateGlobalStats();
    setState(ViewState.IDLE);
  }

  Future<void> updateSubtask(
      Task task, Subtask subtask, String subtaskId) async {
    if (task.subtasks.length > 0) {
      int index =
          task.subtasks.indexWhere((subtask) => subtask.id == subtaskId);
      task.subtasks[index] = subtask;
      task.to = getLastSubtaskToDo(task).to.isAfter(task.to)
          ? getLastSubtaskToDo(task).to
          : task.to;
      task.from = getFirstSubtaskToDo(task).from.isBefore(task.from)
          ? getFirstSubtaskToDo(task).from
          : task.from;
      this.updateTaskStats(task);
      await dbhelper.updateTask(task);
      await updateGlobalStats();
    }
    setState(ViewState.IDLE);
  }

  Future<void> deleteSubtask(Task task, String subtaskId) async {
    if (task.subtasks.length > 0) {
      task.subtasks.removeWhere((subtask) => subtask.id == subtaskId);
      this.updateTaskStats(task);
      await dbhelper.updateTask(task);
      await updateGlobalStats();
    }
    setState(ViewState.IDLE);
  }

  Future<void> updateGlobalStats({Task oldTask, Task task}) async {
    await taskStorage.refreshTaskList();
    totalTasks = tasks.length;

    totalCompletedSubtasks = 0;
    totalCompletedTasks = 0;
    totalFailedTasks = 0;
    totalRunningTasks = 0;
    totalSubtaskCompletedMonth = 0;
    totalSubtaskCompletedWeek = 0;
    totalSubtasks = 0;
    totalUpcomingTasks = 0;
    totalSubtasksDue = 0;

    int totalMinutesTasks = 0;
    int totalMinutesSubtasks = 0;

    for (final task in tasks) {
      if (task.isCompleted) totalCompletedTasks++;

      if (task.isFailed) totalFailedTasks++;

      if (task.from.isAfter(DateTime.now())) totalUpcomingTasks++;

      if (task.from.isBefore(DateTime.now()) && !task.isCompleted)
        totalRunningTasks++;

      totalMinutesTasks +=
          task.from.difference(task.completionTime).abs().inMinutes;

      totalSubtasks += task.totalSubtasks;
      totalCompletedSubtasks += task.subtaskCompleted;

      for (final subtask in task.subtasks) {
        if (subtask.from.isBefore(DateTimeHelper.lastDateOfWeek) &&
            subtask.isCompleted) totalSubtaskCompletedWeek++;

        if (subtask.from.isBefore(DateTimeHelper.lastDateOfMonth) &&
            subtask.isCompleted) totalSubtaskCompletedMonth++;

        if (subtask.to.isBefore(DateTime.now()) && !subtask.isCompleted)
          totalSubtasksDue++;

        totalMinutesSubtasks +=
            subtask.from.difference(subtask.completionTime).abs().inMinutes;
      }
    }
    int averageMinutesTasks = totalTasks <= 0 ? 0 : totalMinutesTasks ~/ totalTasks;
    int averageMinutesSubtasks = totalSubtasks <= 0 ? 0 : totalMinutesSubtasks ~/ totalSubtasks;
    averageTimeSubtasks = Duration(
        hours: averageMinutesSubtasks ~/ 60,
        minutes: averageMinutesSubtasks % 60);
    averageTimeTasks = Duration(
        hours: averageMinutesTasks ~/ 60, minutes: averageMinutesTasks % 60);
  }
}
