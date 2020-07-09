import 'package:first_team_project/core/helper/color_to_hex.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Subtask {
  String id;
  int notificationId;
  DateTime from;
  DateTime to;
  String title;
  bool isCompleted;
  Color subtaskColor;
  DateTime completionTime;
  DateTime notifyBeforeStart;
  DateTime notifyBeforeEnd;

  Subtask({this.id, this.from, this.to, this.title, this.isCompleted = false, this.subtaskColor, this.completionTime, this.notifyBeforeStart, this.notifyBeforeEnd, this.notificationId}) {
    id = id ?? Uuid().v1();
  }

  Subtask.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.from = DateTime.tryParse(json['from']);
    this.to = DateTime.tryParse(json['to']);
    this.title = json['title'];
    this.isCompleted = json['is_completed'] == 1 ? true : false;
    this.subtaskColor = fromHex(json['subtask_color']);
    this.completionTime = json["completion_time"] == null ? this.from : DateTime.tryParse(json['completion_time']);
    this.notifyBeforeStart = json['notify_before_start'] == null ? null : DateTime.tryParse(json['notify_before_start']);
    this.notifyBeforeEnd = json['notify_before_end'] == null ? null : DateTime.tryParse(json['notify_before_end']);
    this.notificationId = json['notification_id'] == null ? null : int.tryParse(json['notification_id']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": this.id,
    "title": this.title,
    "from": this.from.toIso8601String(),
    "to": this.to.toIso8601String(),
    "is_completed": this.isCompleted ? 1 : 0,
    "subtask_color": toHex(this.subtaskColor),
    "completion_time": this.completionTime != null ? this.completionTime.toIso8601String() : null,
    "notify_before_start":  this.notifyBeforeStart == null ? null : this.notifyBeforeStart.toIso8601String(),
    "notify_before_end": this.notifyBeforeEnd == null ? null : this.notifyBeforeEnd.toIso8601String(),
    "notification_id": this.notificationId == null ? null : this.notificationId.toString()
  };


}
