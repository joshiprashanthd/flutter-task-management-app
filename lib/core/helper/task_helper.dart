import 'package:first_team_project/core/models/subtask.dart';
import 'package:first_team_project/core/models/task.dart';
import 'package:first_team_project/core/storage/task_storage.dart';
import 'package:first_team_project/locator.dart';

class TaskHelper {
  TaskStorage _taskStorage = locator<TaskStorage>();

  Task fetchTaskWithId(int taskId) {
    final task = _taskStorage.tasks.firstWhere((task) => task.id == taskId);
    return task;
  }

  void updateTaskStats(Task task) {
    task.totalSubtasks = task.subtasks.length;
    task.subtaskCompleted =
        task.subtasks.where((subtask) => subtask.isCompleted).toList().length;
    task.title.trim();

    for(final subtask in task.subtasks){
      subtask.subtaskColor = task.taskColor;
    }
  }

  List<Subtask> sortSubtasks(Task task) {
    List<Subtask> subtasks = task.subtasks;
    subtasks.sort(
        (subtask1, subtask2) => subtask1.from.isBefore(subtask2.from) ? -1 : 1);
    return subtasks;
  }

  Subtask getFirstSubtaskToDo(Task task) {
    if (task.subtasks == null || task.subtasks.length == 0) return null;
    return sortSubtasks(task)[0];
  }

  Subtask getLastSubtaskToDo(Task task) {
    if (task.subtasks == null || task.subtasks.length == 0) return null;
    return sortSubtasks(task)[task.subtasks.length - 1];
  }

  List<Subtask> allSubtasksOnDate(Task task, DateTime dateTime) {
    if (task.totalSubtasks == 0) return [];
    dateTime = dateTime
        .subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute));
    final sub = task.subtasks.where((subtask) {
      return dateTime.difference(subtask.from).abs().inHours < 24 ||
          (subtask.to.isBefore(DateTime.now()) && !subtask.isCompleted) 
          || (subtask.from.isBefore(dateTime) && subtask.to.isAfter(dateTime));
    });
    return sub.toList();
  }

  List<Task> allTasksOnDate(DateTime dateTime) {
    if (_taskStorage.tasks.length == 0) return [];
    dateTime = dateTime
        .subtract(Duration(hours: dateTime.hour, minutes: dateTime.minute));
    final tasks = _taskStorage.tasks.where((task) {
      return dateTime.difference(task.from).abs().inHours <= 24 || task.from.isBefore(dateTime);
    });
    return tasks.toList();
  }
}
