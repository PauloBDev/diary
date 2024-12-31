import 'dart:async';
import 'dart:convert';

import 'package:diary/models/dailyEntry_model.dart';
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
  late StreamSubscription _dailyEntries;

  List<DailyEntry> taskList = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    _dailyEntries.cancel();
    super.deactivate();
  }

  void _activateListeners() {
    _dailyEntries = _database
        .child(
            'dailyEntries/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
        .onValue
        .listen((event) {
      final tasks = event.snapshot.value.toString();

      if (tasks.isNotEmpty) taskList = getList(tasks);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final _databaseToday = _database.child(
        'dailyEntries/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
    print('Rebuild entryList.dart');

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
                      SizedBox(
                        width: screenWidth * 0.65,
                        child: Text(
                          taskList[index].type.name,
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
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
