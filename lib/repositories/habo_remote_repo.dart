import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/repositories/habo_repo_interface.dart';

class HaboRemoteRepository implements HaboRepoInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> clearDatabase() async {
    // Todo: Clear the remote database
  }

  @override
  Future<void> deleteEvent(String id, DateTime dateTime) async {
    await _firestore
        .collection('habits')
        .doc(id)
        .collection('events')
        .doc(dateTime.toIso8601String())
        .delete();
  }

  @override
  Future<void> deleteHabit(String id) async {
    // Delete the habit
    await _firestore.collection('habits').doc(id).delete();

    //delete all associated events
    var eventsSnapshot = await _firestore
        .collection('habits')
        .doc(id)
        .collection('events')
        .get();
    for (var doc in eventsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> editHabit(Habit habit) async {
    await _firestore
        .collection('habits')
        .doc(habit.habitData.id)
        .update(habit.toMap());
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    var habitsSnapshot =
        await _firestore.collection('habits').orderBy('position').get();
    List<Habit> habits = [];

    for (var habitDoc in habitsSnapshot.docs) {
      Map<String, dynamic> habitData = habitDoc.data();
      habitData['id'] = habitDoc.id; // Ensure the id is included

      var eventsSnapshot = await _firestore
          .collection('habits')
          .doc(habitDoc.id)
          .collection('events')
          .get();

      Map<String, dynamic> eventsMap = {};
      for (var eventDoc in eventsSnapshot.docs) {
        Map<String, dynamic> eventData = eventDoc.data();
        String eventDateStr =
            eventData['date']; // ISO 8601 string representation
        eventsMap[eventDateStr] = [eventData['type'], eventData['comment']];
      }

      habitData['events'] = eventsMap;
      Habit habit = Habit.fromJson(habitData);
      habits.add(habit);
    }
    return habits;
  }

  @override
  Future<void> insertEvent(String id, DateTime date, List event) async {
    Map<String, dynamic> eventData = {
      "date": date.toString(),
      "type": event[0].toString(),
      "comment": event[1]
    };
    await _firestore
        .collection('habits')
        .doc(id)
        .collection('events')
        .doc(date.toIso8601String())
        .set(eventData);
  }

  @override
  Future<void> insertHabit(Habit habit) async {
    await _firestore
        .collection('habits')
        .doc(habit.habitData.id)
        .set(habit.toMap());
  }

  @override
  Future<void> updateOrder(List<Habit> habits) async {
    WriteBatch batch = _firestore.batch();
    for (var habit in habits) {
      var habitRef = _firestore.collection("habits").doc(habit.habitData.id);
      batch.update(habitRef, {'position': habit.habitData.position});
    }
    await batch.commit();
  }

  @override
  Future<void> useBackup(List<Habit> habits) async {
    // Todo: Update the remote database from backup file
  }
}
