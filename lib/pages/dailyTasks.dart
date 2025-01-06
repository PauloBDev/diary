import 'dart:async';
import 'dart:convert';

import 'package:diary/models/task_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/repositories/simpleMethods.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DailyTaskManagement extends StatefulWidget {
  const DailyTaskManagement({super.key});

  @override
  State<DailyTaskManagement> createState() => _DailyTaskManagementState();
}

class _DailyTaskManagementState extends State<DailyTaskManagement> {
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

    print('Rebuild dailyTaskManagement.dart');

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
            style: const TextStyle(color: Colors.white),
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
                onTap: () => _addTaskDialog(context),
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
                    "Add a daily task!",
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

  _addTaskDialog(BuildContext context) {
    final taskController = TextEditingController();
    final addTask = _database.child('dailyTasks/');

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
}
