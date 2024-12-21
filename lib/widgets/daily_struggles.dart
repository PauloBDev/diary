import 'dart:async';
import 'dart:convert';

import 'package:diary/models/task_model.dart';
import 'package:diary/pages/dailyStrugglesEntries.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class DailyStrugglesList extends StatefulWidget {
  const DailyStrugglesList({
    super.key,
  });

  @override
  State<DailyStrugglesList> createState() => _DailyStrugglesListState();
}

class _DailyStrugglesListState extends State<DailyStrugglesList> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailyTasks;
  String _displayFirstTask = 'Task name is: ';

  List<DailyEntry> taskList = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    _dailyTasks.cancel();
    super.deactivate();
  }

  void _activateListeners() {
    _dailyTasks = _database
        .child(
            'dailyStruggles/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
        .onValue
        .listen((event) {
      // final test = event.snapshot.value.toString();
      // final result = jsonDecode(jsonEncode(test));
      // print('Result: ${result}');

      // final values = result['result']['values'] as Map<String, dynamic>;

      // final decoded = values.values.first;

      // print('Result: ${decoded}');

      // for (var key in result.value) print("${key}: ${result[key]}");

      final tasks = event.snapshot.value.toString();

      // print('Tasks of today: ${tasks.substring(tasks.indexOf('timeStamp'))}');

      if (tasks.isNotEmpty) taskList = getList(tasks);

      for (var task in taskList) {
        print(
            '${task.id} - ${task.taskName} - ${task.completed} - ${task.timeStamp}');
      }

      setState(() {
        _displayFirstTask = 'Today first task name is: ${taskList[0].taskName}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final _databaseToday = _database.child(
        'dailyStruggles/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
    print('Rebuild taskList.dart');

    return BlocProvider(
      create: (context) =>
          TaskBloc(RepositoryProvider.of<TaskRepository>(context))
            ..add(TaskLoading()),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: taskList.length,
            itemBuilder: ((
              context,
              index,
            ) {
              return Card(
                color: Colors.grey,
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Checkbox(
                        value: taskList[index].completed,
                        onChanged: (value) {
                          _databaseToday
                              .child('${taskList[index].id}/')
                              .update({'completed': value!});
                        },
                      ),
                      SizedBox(
                        width: screenWidth * 0.65,
                        child: Text(
                          taskList[index].taskName ?? 'Failed to get task name',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const DailyStrugglesEntries()),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    "Add a entry.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    .animate(
                  delay: 0.milliseconds,
                  onPlay: (controller) => controller.repeat(),
                )
                    .shimmer(colors: [
                  Colors.green,
                  Colors.red,
                  Colors.green,
                ], duration: 3000.milliseconds),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTaskDialog(BuildContext context) {
    final taskController = TextEditingController();
    final addTask = _database.child(
        'dailyStruggles/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
    print(
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');

    return showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: IntrinsicHeight(
            child: Container(
              // constraints: const BoxConstraints(
              //     minWidth: double.infinity, minHeight: 50, maxHeight: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Material(
                color: Colors.blue.shade400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: DefaultTextStyle(
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32,
                            color: Colors.grey.shade300),
                        child: const Text('Add a Task!'),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {},
                      controller: taskController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final newRefAddTask = addTask.push();

                            await newRefAddTask.set({
                              'id': newRefAddTask.key,
                              'taskName': taskController.text,
                              'timeStamp': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'completed': false,
                            });

                            Navigator.pop(context);
                            // context
                            //     .read<TaskBloc>()
                            //     .add(AddTask(task as Task, taskList));
                          },
                          child: const Text('Confirm'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(
              0,
              1,
            ),
            end: const Offset(
              0,
              0,
            ),
          ).animate(
            anim1,
          ),
          child: child,
        );
      },
    );
  }

  List<DailyEntry> getList(String tasks) {
    final List<String> taskStringList = [];
    final List<DailyEntry> taskList = [];

    final jsonString = tasks
        .replaceAll(RegExp(r'\+'), '') // To remove all white spaces
        .replaceAll(
            RegExp(r':'), '":"') // To add double-quotes on both sides of colon
        .replaceAll(
            RegExp(r','), '","') // To add double-quotes on both sides of comma
        .replaceAll(RegExp(r'{'),
            '{"') // To add double-quotes after every open curly bracket
        .replaceAll(RegExp(r'}'), '"}');

    print('Initial String: $jsonString');

    final jsonSplitAllDynamicOut = jsonString.split('":" {');

    for (var i = 1; i < jsonSplitAllDynamicOut.length; i++) {
      final test = jsonSplitAllDynamicOut[i].split('}"," ');

      if (test.runtimeType != String) {
        if (test[0].contains('"}"}')) {
          taskStringList.add('{${test[0].replaceAll('"}"}', '"}')}');
        } else {
          taskStringList.add('{${test[0]}}');
        }
      }
    }

    print('String List: $taskStringList');

    // final jsonStringForRaw = jsonString
    //     .replaceFirst('":"', '":')
    //     .replaceFirst('":" {', '":{')
    //     .replaceFirst('"}"}', '"}}')
    //     .split('": {"')[1];

    // final jsonStringRaw =
    //     '{"${jsonStringForRaw.substring(0, jsonStringForRaw.length - 1)}';

    // final jsonStringSplit = jsonStringRaw.split('}","');

    // // print('before for: $jsonStringSplit');

    // for (var i = 0; i < jsonStringSplit.length; i++) {
    //   if (i == 0) {
    //     // print('At first: ${jsonStringSplit[i]}');
    //     if (jsonStringSplit.length == 1) {
    //       final tempString = jsonStringSplit[i]
    //           .replaceAll('":" ', '":"')
    //           .replaceAll('"," ', '","');

    //       taskStringList.add(tempString);

    //       // print('first and last: $tempString');

    //       continue;
    //     }
    //     final tempString = jsonStringSplit[i]
    //         .replaceAll('":" ', '":"')
    //         .replaceAll('"," ', '","');

    //     taskStringList.add('$tempString}');

    //     // print('first: $tempString}');
    //     continue;
    //   }

    //   if (i == jsonStringSplit.length - 1) {
    //     // print('At last: ${jsonStringSplit[i]}');
    //     final jsonStringForRaw =
    //         jsonStringSplit[i].substring(tasks.indexOf('timeStamp'));

    //     // print('timestamp index removal: $jsonStringForRaw');
    //     final jsonStringForList = jsonStringForRaw
    //         .replaceAll('":" ', '":"')
    //         .replaceAll('"," ', '","');

    //     taskStringList.add(jsonStringForList);

    //     // print('last: $jsonStringForList');
    //     continue;
    //   }

    //   // print('At ${i + 1}º: ${jsonStringSplit[i]}');
    //   final jsonStringForList = jsonStringSplit[i]
    //       .substring(tasks.indexOf('timeStamp'))
    //       .replaceAll('":" ', '":"')
    //       .replaceAll('"," ', '","');

    //   taskStringList.add('{$jsonStringForList}');

    //   // print('At ${i + 1}º {$jsonStringForList}');
    // }

    for (var task in taskStringList) {
      print('went in the fromJason: $task');
      final model = DailyEntry.fromJson(
          jsonDecode(task.replaceAll('":" ', '":"').replaceAll('"," ', '","')));
      print('Model: $model');
      taskList.add(model);
    }

    taskList.sort((a, b) {
      return a.timeStamp!.compareTo(b.timeStamp!);
    });

    return taskList;
  }
}
