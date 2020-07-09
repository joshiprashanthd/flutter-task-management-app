import 'dart:convert';
import 'package:first_team_project/core/helper/color_to_hex.dart';
import 'package:flutter/material.dart';
import 'subtask.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Task {
  int id;
  String title;
  String description;
  DateTime from;
  DateTime to;
  List<Subtask> subtasks;
  int totalSubtasks;
  int subtaskCompleted;
  Color taskColor;
  bool isCompleted;
  bool isFailed;
  DateTime completionTime;

  Task({
    @required this.title,
    this.description,
    this.from,
    this.to,
    this.subtasks,
    this.subtaskCompleted = 0,
    this.totalSubtasks = 0,
    this.taskColor = Colors.blue,
    this.isCompleted = false,
    this.isFailed = false,
    this.completionTime,
  }) {
    from = from ?? DateTime.now();
    to = to ?? DateTime.now().add(Duration(days: 1));

    if (subtasks != null) {
      totalSubtasks = subtasks.length;
      for (var i = 0; i < totalSubtasks; i++) {
        if (subtasks[i].isCompleted) subtaskCompleted++;
      }
      updateSubtaskInfo();
    }
  }

  void updateSubtaskInfo() {
    if (subtasks != null) {
      for (var i = 0; i < totalSubtasks; i++) {
        subtasks[i].subtaskColor = this.taskColor;
      }
    }
  }

  List<Subtask> get todaySubtasks {
    return subtasks.where((subtask) => subtask.from.difference(DateTime.now()).abs().inHours < 24).toList();
  }

  Task.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] as int;
    this.title = json['title'];
    this.description = json['description'];
    this.from = DateTime.tryParse(json['from_']);
    this.to = DateTime.tryParse(json['to_']);
    if (jsonDecode(json['subtasks']) != null) {
      this.subtasks = (jsonDecode(json['subtasks']) as List)
          .map((subtask) => Subtask.fromJson(subtask))
          .toList();
    }
    this.totalSubtasks = json['total_subtasks'] as int;
    this.subtaskCompleted = json['subtask_completed'] as int;
    this.taskColor = fromHex(json['task_color']);
    this.isCompleted = (json['is_completed'] as int) == 1;
    this.isFailed = (json['is_failed'] as int) == 1;
    this.completionTime = json['completion_time'] == null ? this.from : DateTime.tryParse(json['completion_time']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "title": this.title,
      "description": this.description,
      "from_": this.from.toIso8601String(),
      "to_": this.to.toIso8601String(),
      "total_subtasks": this.totalSubtasks,
      "subtask_completed": this.subtaskCompleted,
      "task_color": toHex(this.taskColor),
      "subtasks": jsonEncode(this.subtasks),
      "is_completed": this.isCompleted ? 1 : 0,
      "is_failed": this.isFailed ? 1 : 0,
      "completion_time": this.completionTime != null ? this.completionTime.toIso8601String() : null
    };
    if (this.id != null){
      map["id"] = id;
    }

    return map;
  }
}
