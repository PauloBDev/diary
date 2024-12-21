import 'dart:convert';

import 'package:diary/models/task_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';

class TaskRepository {
  String endpoint = 'https://dummyjson.com/todos';

  final database = FirebaseDatabase.instance.ref();

  Future<List<DailyEntry>> getTasks() async {
    final database = FirebaseDatabase.instance.ref();

    final results = database.child('dailyTasks').onValue.map((event) {
      final taskMap = Map<String, dynamic>.from(
          event.snapshot.value as Map<String, dynamic>);

      final taskList = taskMap.entries.map((e) {
        return DailyEntry.fromJson(e.value);
      }).toList();

      return taskList;
    });

    print('List: ${results.map((e) => '$e').toList()}');
    // _database.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value;
    //   print('Data: ${data}');
    // });

    final Response response = await get(Uri.parse(endpoint));

    print(response);

    if (response.statusCode == 200) {
      print('200');

      final List result = jsonDecode(response.body)['todos'];

      return result.map((e) => DailyEntry.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  List<DailyEntry> removeTask(String? id, List<DailyEntry> tasks) {
    tasks.removeWhere((element) => element.id == id);
    return tasks;
  }

  List<DailyEntry> addTask(DailyEntry task, List<DailyEntry> tasks) {
    print('Adding task $task');
    final addTask = database.push();

    print(addTask);

    return tasks;
  }

  List<DailyEntry> editTask(int index, List<DailyEntry> tasks) {
    tasks[index].completed = !tasks[index].completed;
    return tasks;
  }
}
