import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habo/habits/habit.dart';
import 'package:habo/models/user_data.dart';
import 'package:habo/repositories/habo_repo_interface.dart';
import 'package:habo/repositories/user_repository.dart';

class HaboRemoteRepository implements HaboRepoInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository userRepository;

  HaboRemoteRepository({required this.userRepository});

  @override
  Future<void> clearDatabase() async {
    // Clear all habits for the specific user
    String userId = await _getUserId();
    var habitsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .get();

    for (var doc in habitsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> deleteEvent(String id, DateTime dateTime) async {
    String userId = await _getUserId();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(id)
        .collection('events')
        .doc(dateTime.toIso8601String())
        .delete();
  }

  @override
  Future<void> deleteHabit(String id) async {
    String userId = await _getUserId();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(id)
        .delete();

    // Delete all associated events
    var eventsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
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
    String userId = await _getUserId();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.habitData.id)
        .update(habit.toMap());
  }

  @override
  Future<List<Habit>> getAllHabits() async {
    String userId = await _getUserId();

    var habitsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('position')
        .get();

    List<Habit> habits = [];

    // Process each habit document
    for (var habitDoc in habitsSnapshot.docs) {
      Map<String, dynamic> habitData = habitDoc.data();
      habitData['id'] = habitDoc.id;

      var eventsSnapshot = await habitDoc.reference.collection('events').get();

      Map<String, dynamic> eventsMap = {};
      for (var eventDoc in eventsSnapshot.docs) {
        Map<String, dynamic> eventData = eventDoc.data();
        String eventDateStr = eventData['date'];
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
    String userId = await _getUserId();

    Map<String, dynamic> eventData = {
      "date": date.toString(),
      "type": event[0].toString(),
      "comment": event[1]
    };
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(id)
        .collection('events')
        .doc(date.toIso8601String())
        .set(eventData);
  }

  @override
  Future<void> insertHabit(Habit habit) async {
    String userId = await _getUserId();

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.habitData.id)
        .set(habit.toMap());
  }

  @override
  Future<void> updateOrder(List<Habit> habits) async {
    String userId = await _getUserId();

    WriteBatch batch = _firestore.batch();
    for (var habit in habits) {
      var habitRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habit.habitData.id);
      batch.update(habitRef, {'position': habit.habitData.position});
    }
    await batch.commit();
  }

  @override
  Future<void> useBackup(List<Habit> habits) async {
    // Clear existing data first
    await clearDatabase();

    // Insert each habit from the backup
    for (var habit in habits) {
      await insertHabit(habit);

      // Insert associated events for each habit
      habit.habitData.events.forEach((dateTime, event) async {
        await insertEvent(habit.habitData.id!, dateTime, event);
      });
    }
  }

  Future<String> _getUserId() async {
    UserData userData = await userRepository.getUser();
    String userId = userData.uid;
    return userId;
  }
}
