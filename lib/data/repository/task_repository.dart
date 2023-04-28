import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/domain/models/task.dart';
import 'package:my_flutter_app/domain/constants/constants.dart';

class TaskRepository {
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final data = doc.data() as dynamic;
            return Task(
              id: doc.id,
              title: data[Constants.title],
              description: data[Constants.description],
              completed: data[Constants.completed]
            );
          },
        ).toList();
      },
    );
  }

  Future<void> addTask(Task task) {
    return taskCollection.add({
      Constants.title: task.title,
      Constants.description: task.description,
      Constants.completed: task.completed,
    });
  }

  Future<void> updateTask(Task task) {
    return taskCollection.doc(task.id).update({
      Constants.title: task.title,
      Constants.description: task.description,
      Constants.completed: task.completed,
    });
  }

  Future<void> deleteTask(Task task) {
    return taskCollection.doc(task.id).delete();
  }
}
