import 'package:flutter/foundation.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/repositories/habo_repo_interface.dart';

class HaboRemoteRepository implements HaboRepoInterface {
  @override
  Future<void> clearDatabase() async {
    debugPrint("Remote clearDatabase");
  }

  @override
  Future<void> deleteEvent(String id, DateTime dateTime) async {
    debugPrint("Remote deleteEvent");
  }

  @override
  Future<void> deleteHabit(String id) async {
    debugPrint("Remote deleteHabit");
  }

  @override
  Future<void> editHabit(Habit habit) async {
    debugPrint("Remote editHabit");
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    debugPrint("Remote getAllHabits");
    return [];
  }

  @override
  Future<void> insertEvent(String id, DateTime date, List event) async {
    debugPrint("Remote Insert Event");
  }

  @override
  Future<void> insertHabit(Habit habit) async {
    debugPrint("Remote Insert Habit");
  }

  @override
  Future<void> updateOrder(List<Habit> habits) async {
    debugPrint("Remote Update Order");
  }

  @override
  Future<void> useBackup(List<Habit> habits) async {
    debugPrint("Remote useBackup");
  }
}
