import 'dart:async';
import 'dart:convert';

import 'package:diary/models/task_model.dart';
import 'package:diary/pages/dailyTasks.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/repositories/simpleMethods.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:diary/widgets/dailyTaskDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DailyTaskList extends StatefulWidget {
  const DailyTaskList({
    super.key,
  });

  @override
  State<DailyTaskList> createState() => _DailyTaskListState();
}

class _DailyTaskListState extends State<DailyTaskList> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailyTasks;

  List<DailyTask> taskList = [];

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
    _dailyTasks = _database.child('dailyTasks/').onValue.listen((event) {
      final tasks = event.snapshot.value.toString();

      if (tasks.isNotEmpty) taskList = GetMethods().getDailyTasks(tasks);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final databaseToday = _database.child('dailyTasks/');
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
                color: Colors.transparent,
                margin: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.5,
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
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                DateFormat('hh:mm a')
                                    .format(
                                        (DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(
                                                taskList[index].timeStamp!))))
                                    .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
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
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const DailyTaskDialog(),
                    );
                  },
                  child: SizedBox(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: const Text(
                          "Add a daily task!",
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
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const DailyTaskManagement()),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: const Text(
                          "Manage your tasks",
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
          ),
        ],
      ),
    );
  }
}
