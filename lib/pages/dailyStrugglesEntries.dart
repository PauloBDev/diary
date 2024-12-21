import 'dart:async';
import 'dart:convert';

import 'package:diary/models/task_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DailyStrugglesEntries extends StatefulWidget {
  const DailyStrugglesEntries({super.key});

  @override
  State<DailyStrugglesEntries> createState() => _DailyStrugglesEntriesState();
}

class _DailyStrugglesEntriesState extends State<DailyStrugglesEntries> {
  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _dailyTasks;

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
      final tasks = event.snapshot.value.toString();

      if (tasks.isNotEmpty) taskList = getList(tasks);

      for (var task in taskList) {
        print(
            '${task.id} - ${task.taskName} - ${task.completed} - ${task.timeStamp}');
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final databaseToday = _database.child(
        'dailyStruggles/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');

    return BlocProvider(
      create: (context) =>
          TaskBloc(RepositoryProvider.of<TaskRepository>(context))
            ..add(TaskLoading()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0.0,
          title: const Text(
            'Diary',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.settings)),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showEntryDialog(),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                      child: Text(
                    "Add a entry",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: taskList.length,
                itemBuilder: ((
                  context,
                  index,
                ) {
                  return Row(
                    children: [
                      Flexible(
                        child: Card(
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Colors.white)),
                            child: Row(
                              children: [
                                Checkbox(
                                  hoverColor: Colors.white,
                                  value: taskList[index].completed,
                                  onChanged: (value) {
                                    databaseToday
                                        .child('${taskList[index].id}/')
                                        .update({'completed': value!});
                                  },
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.35,
                                        child: Text(
                                          taskList[index].taskName ??
                                              'Failed to get task name',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          DateFormat('hh:mm a')
                                              .format((DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      int.parse(taskList[index]
                                                          .timeStamp!))))
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: GestureDetector(
                          onTap: () => {},
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showEntryDialog() {
    print('Build Dialog');
    final addDailyEntry = _database.child('dailyStruggles/');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
          "Add an entry",
          style: TextStyle(color: Colors.white),
        )),
        content: Text(
            'fndjasiktghhlfadbtgfkjdsangfdsailhgbfdlasgbfdsilgbfdsigldfsbgfdsihbfgdsjikgbnfdsligbfsigbfdslhkgbdfshlkjgbfdlsgbfdhsbgdsflkgbfdsbgdfsljgbdfslgbdfshgdfsbgfdhkbgfdsbgdsfihbudfsjkgdlfsbgdfsigbdfslgbfds'),
        actions: [
          TextButton(onPressed: () => {}, child: Text('Confirm')),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      ),
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

    for (var task in taskStringList) {
      final model = DailyEntry.fromJson(
          jsonDecode(task.replaceAll('":" ', '":"').replaceAll('"," ', '","')));
      taskList.add(model);
    }

    taskList.sort((a, b) {
      return a.timeStamp!.compareTo(b.timeStamp!);
    });

    return taskList;
  }
}
