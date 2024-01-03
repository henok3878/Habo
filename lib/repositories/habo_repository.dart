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
    await _localRepo.clearDatabase();
  }

  @override
  Future<void> deleteEvent(String id, DateTime dateTime) async {
    await _localRepo.deleteEvent(id, dateTime);
    await _remoteRepo.deleteEvent(id, dateTime);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _localRepo.deleteHabit(id);
    await _remoteRepo.deleteHabit(id);
  }

  @override
  Future<void> editHabit(Habit habit) async {
    await _localRepo.editHabit(habit);
    await _remoteRepo.editHabit(habit);
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    if (allHabits.isEmpty) {
      allHabits = await _localRepo.getAllHabits();
      if (allHabits.isEmpty) {
        allHabits = await _remoteRepo.getAllHabits();
        await _localRepo.useBackup(allHabits);
      }
    }
    return allHabits;
  }

  @override
  Future<void> insertEvent(String id, DateTime date, List event) async {
    await _localRepo.insertEvent(id, date, event);
    await _remoteRepo.insertEvent(id, date, event);
  }

  @override
  Future<void> insertHabit(Habit habit) async {
    await _localRepo.insertHabit(habit);
    await _remoteRepo.insertHabit(habit);
    // // Initiate the remote repository update in the background
    // _remoteRepo.insertHabit(habit).catchError((error) {
    //   debugPrint("Error updating remote repository: $error");
    // });
  }

  @override
  Future<void> updateOrder(List<Habit> habits) async {
    await _localRepo.updateOrder(habits);
    await _remoteRepo.updateOrder(habits);

    // // Initiate the remote repository update in the background
    // _remoteRepo.updateOrder(habits).catchError((error) {
    //   debugPrint("Error updating order remote repository: $error");
    // });
  }

  @override
  Future<void> useBackup(List<Habit> habits) async {
    await _localRepo.useBackup(habits);
    await _remoteRepo.useBackup(habits);
  }
}
