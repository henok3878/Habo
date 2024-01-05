import 'package:flutter/foundation.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/repositories/habo_repo_interface.dart';

class HaboRepository implements HaboRepoInterface {
  final HaboRepoInterface _localRepo;
  final HaboRepoInterface _remoteRepo;

  //in-memory cache here to improve performance
  List<Habit> allHabits = [];

  HaboRepository(
      {required HaboRepoInterface localRepo,
      required HaboRepoInterface remoteRepo})
      : _localRepo = localRepo,
        _remoteRepo = remoteRepo {
    // getAllHabits().then((value) => allHabits = value);
  }

  @override
  Future<void> clearDatabase() async {
    await _localRepo.clearDatabase();
    // Initiate the remote repository update in the background
    _remoteRepo.clearDatabase().catchError((error) {
      debugPrint("Error clearing remote db: $error");
    });
  }

  @override
  Future<void> deleteEvent(String id, DateTime dateTime) async {
    await _localRepo.deleteEvent(id, dateTime);
    // Initiate the remote repository update in the background
    await _remoteRepo.deleteEvent(id, dateTime).catchError((error) {
      debugPrint("Error deleting event from remote repository: $error");
    });
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _localRepo.deleteHabit(id);
    // Initiate the remote repository update in the background
    _remoteRepo.deleteHabit(id).catchError((error) {
      debugPrint("Error deleting habit from remote repository: $error");
    });
  }

  @override
  Future<void> editHabit(Habit habit) async {
    await _localRepo.editHabit(habit);
    // Initiate the remote repository update in the background
    _remoteRepo.editHabit(habit).catchError((error) {
      debugPrint("Error editing habit to remote repository: $error");
    });
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    try {
      // Try to fetch habits from Firestore
      allHabits = await _remoteRepo.getAllHabits();

      // Update the local repository in the background
      _localRepo.useBackup(allHabits).catchError((e) {
        // Handle or log error if local update fails
        debugPrint("Error updating local repository: $e");
      });
    } catch (e) {
      // If fetching from Firestore fails, fall back to the local repository
      debugPrint("Error fetching from Firestore: $e");
      allHabits = await _localRepo.getAllHabits();
    }

    return allHabits;
  }

  @override
  Future<void> insertEvent(String id, DateTime date, List event) async {
    await _localRepo.insertEvent(id, date, event);

    // Initiate the remote repository update in the background
    _remoteRepo.insertEvent(id, date, event).catchError((error) {
      debugPrint("Error inserting event to remote repository: $error");
    });
  }

  @override
  Future<void> insertHabit(Habit habit) async {
    await _localRepo.insertHabit(habit);
    // Initiate the remote repository update in the background
    _remoteRepo.insertHabit(habit).catchError((error) {
      debugPrint("Error updating remote repository: $error");
    });
  }

  @override
  Future<void> updateOrder(List<Habit> habits) async {
    await _localRepo.updateOrder(habits);
    // Initiate the remote repository update in the background
    _remoteRepo.updateOrder(habits).catchError((error) {
      debugPrint("Error updating order remote repository: $error");
    });
  }

  @override
  Future<void> useBackup(List<Habit> habits) async {
    await _localRepo.useBackup(habits);
    await _remoteRepo.useBackup(habits);
  }
}
