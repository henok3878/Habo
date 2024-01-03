import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class HabitData {
  HabitData({
    String? id,
    required this.position,
    required this.title,
    required this.twoDayRule,
    required this.cue,
    required this.routine,
    required this.reward,
    required this.showReward,
    required this.advanced,
    required this.notification,
    required this.notTime,
    required this.events,
    required this.sanction,
    required this.showSanction,
    required this.accountant,
  }) : id = id ?? const Uuid().v4();

  SplayTreeMap<DateTime, List> events;
  int streak = 0;
  String? id;
  int position;
  String title;
  bool twoDayRule;
  String cue;
  String routine;
  String reward;
  bool showReward;
  bool advanced;
  bool notification;
  TimeOfDay notTime;
  String sanction;
  bool showSanction;
  String accountant;
}
