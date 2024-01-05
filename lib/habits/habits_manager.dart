import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:habo/constants.dart';
import 'package:habo/generated/l10n.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/models/habit_data.dart';
import 'package:habo/notifications.dart';
import 'package:habo/repositories/backup.dart';
import 'package:habo/repositories/habo_repo_interface.dart';
import 'package:habo/statistics/statistics.dart';
import 'package:habo/utils/dependency_injector.dart';

class HabitsManager extends ChangeNotifier {
  late HaboRepoInterface _haboRepo;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late List<Habit> allHabits = [];
  bool _isInitialized = false;

  Habit? deletedHabit;
  Queue<Habit> toDelete = Queue();

  void initialize() async {
    await initModel();
    await Future.delayed(const Duration(seconds: 5));
    notifyListeners();
  }

  resetHabitsNotifications() {
    resetNotifications(allHabits);
  }

  initModel() async {
    _haboRepo = await DependencyInjector.getHaboRepository();
    allHabits = await _haboRepo.getAllHabits();
    _isInitialized = true;
    notifyListeners();
  }

  GlobalKey<ScaffoldMessengerState> get getScaffoldKey {
    return _scaffoldKey;
  }

  void hideSnackBar() {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
  }

  Future<bool> createBackup() async {
    try {
      final file = await Backup.writeBackup(allHabits);
      if (Platform.isAndroid || Platform.isIOS) {
        final params = SaveFileDialogParams(
          sourceFilePath: file.path,
          mimeTypesFilter: ['application/json'],
        );
        await FlutterFileDialog.saveFile(params: params);
      } else {
        final outputFile = await FilePicker.platform.saveFile(
          dialogTitle: '',
          type: FileType.custom,
          allowedExtensions: ['json'],
          fileName: file.path.split('/').last,
        );
        if (outputFile != null) {
          await file.copy(outputFile);
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> loadBackup() async {
    try {
      final String? filePath;
      if (Platform.isAndroid || Platform.isIOS) {
        const params = OpenFileDialogParams(
          fileExtensionsFilter: ['json'],
          mimeTypesFilter: ['application/json'],
        );
        filePath = await FlutterFileDialog.pickFile(params: params);
      } else {
        filePath = (await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
                allowMultiple: false,
                withReadStream: Platform.isLinux))
            ?.files
            .first
            .path;
      }
      if (filePath == null) {
        return true;
      }
      final json = await Backup.readBackup(filePath);
      List<Habit> habits = [];
      jsonDecode(json).forEach((element) {
        habits.add(Habit.fromJson(element));
      });
      await _haboRepo.useBackup(habits);
      removeNotifications(allHabits);
      allHabits = habits;
      resetNotifications(allHabits);
      notifyListeners();
    } catch (e) {
      return false;
    }
    return true;
  }

  resetNotifications(List<Habit> habits) {
    for (var element in habits) {
      if (element.habitData.notification) {
        var data = element.habitData;
        setHabitNotification(
            data.id.hashCode, data.notTime, 'Habo', data.title);
      }
    }
  }

  removeNotifications(List<Habit> habits) {
    for (var element in habits) {
      disableHabitNotification(element.habitData.id.hashCode);
    }
  }

  showErrorMessage(String message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: HaboColors.red,
      ),
    );
  }

  List<Habit> get getAllHabits {
    return allHabits;
  }

  bool get isInitialized {
    return _isInitialized;
  }

  reorderList(oldIndex, newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    Habit moved = allHabits.removeAt(oldIndex);
    allHabits.insert(newIndex, moved);
    updateOrder();
    _haboRepo.updateOrder(allHabits);
    notifyListeners();
  }

  addEvent(String id, DateTime dateTime, List event) {
    _haboRepo.insertEvent(id, dateTime, event);
  }

  deleteEvent(String id, DateTime dateTime) {
    _haboRepo.deleteEvent(id, dateTime);
  }

  addHabit(
      String title,
      bool twoDayRule,
      String cue,
      String routine,
      String reward,
      bool showReward,
      bool advanced,
      bool notification,
      TimeOfDay notTime,
      String sanction,
      bool showSanction,
      String accountant) async {
    Habit newHabit = Habit(
      habitData: HabitData(
        position: allHabits.length,
        title: title,
        twoDayRule: twoDayRule,
        cue: cue,
        routine: routine,
        reward: reward,
        showReward: showReward,
        advanced: advanced,
        events: SplayTreeMap<DateTime, List>(),
        notification: notification,
        notTime: notTime,
        sanction: sanction,
        showSanction: showSanction,
        accountant: accountant,
      ),
    );
    await _haboRepo.insertHabit(newHabit);
    allHabits.add(newHabit);

    if (notification) {
      setHabitNotification(newHabit.habitData.hashCode, notTime, 'Habo', title);
    } else {
      disableHabitNotification(newHabit.habitData.id!.hashCode);
    }
    notifyListeners();
    updateOrder();
  }

  editHabit(HabitData habitData) {
    Habit? hab = findHabitById(habitData.id!);
    if (hab == null) return;
    hab.habitData.title = habitData.title;
    hab.habitData.twoDayRule = habitData.twoDayRule;
    hab.habitData.cue = habitData.cue;
    hab.habitData.routine = habitData.routine;
    hab.habitData.reward = habitData.reward;
    hab.habitData.showReward = habitData.showReward;
    hab.habitData.advanced = habitData.advanced;
    hab.habitData.notification = habitData.notification;
    hab.habitData.notTime = habitData.notTime;
    hab.habitData.sanction = habitData.sanction;
    hab.habitData.showSanction = habitData.showSanction;
    hab.habitData.accountant = habitData.accountant;
    _haboRepo.editHabit(hab);
    if (habitData.notification) {
      setHabitNotification(
          habitData.id!.hashCode, habitData.notTime, 'Habo', habitData.title);
    } else {
      disableHabitNotification(habitData.id!.hashCode);
    }
    notifyListeners();
  }

  String getNameOfHabit(String id) {
    Habit? hab = findHabitById(id);
    return (hab != null) ? hab.habitData.title : '';
  }

  Habit? findHabitById(String id) {
    Habit? result;
    for (var hab in allHabits) {
      if (hab.habitData.id == id) {
        result = hab;
      }
    }
    return result;
  }

  deleteHabit(String id) {
    deletedHabit = findHabitById(id);
    allHabits.remove(deletedHabit);
    toDelete.addLast(deletedHabit!);
    Future.delayed(const Duration(seconds: 4), () => deleteFromDB());
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(S.current.habitDeleted),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: S.current.undo,
          onPressed: () {
            undoDeleteHabit(deletedHabit!);
          },
        ),
      ),
    );
    updateOrder();
    notifyListeners();
  }

  undoDeleteHabit(Habit del) {
    toDelete.remove(del);
    if (deletedHabit != null) {
      if (deletedHabit!.habitData.position < allHabits.length) {
        allHabits.insert(deletedHabit!.habitData.position, deletedHabit!);
      } else {
        allHabits.add(deletedHabit!);
      }
    }

    updateOrder();
    notifyListeners();
  }

  Future<void> deleteFromDB() async {
    if (toDelete.isNotEmpty) {
      disableHabitNotification(toDelete.first.habitData.id.hashCode);
      _haboRepo.deleteHabit(toDelete.first.habitData.id!);
      toDelete.removeFirst();
    }
    if (toDelete.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () => deleteFromDB());
    }
  }

  updateOrder() {
    int iterator = 0;
    for (var habit in allHabits) {
      habit.habitData.position = iterator++;
    }
  }

  Future<AllStatistics> getFutureStatsData() async {
    return await Statistics.calculateStatistics(allHabits);
  }
}
