import 'package:habo/habits/habit.dart';

abstract class HaboRepoInterface {
  Future<void> deleteEvent(String id, DateTime dateTime);
  Future<void> deleteHabit(String id);

  // equavlent of Future<void> emptyTables() for the current version
  Future<void> clearDatabase();
  Future<void> useBackup(List<Habit> habits);
  Future<void> editHabit(Habit habit);
  Future<List<Habit>> getAllHabits();
  Future<void> insertEvent(String id, DateTime date, List event);
  Future<void> insertHabit(Habit habit);
  Future<void> updateOrder(List<Habit> habits);
}
