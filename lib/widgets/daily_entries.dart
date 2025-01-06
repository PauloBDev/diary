import 'dart:async';
import 'dart:convert';

import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/task_model.dart';
import 'package:diary/pages/dailyEntries.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/repositories/simpleMethods.dart';
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

  List<DailyEntry> entriesList = [];

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
        .child('dailyEntries/permanent')
        // ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}

        .onValue
        .listen((event) {
      final entries = event.snapshot.value.toString();

      if (entries.isNotEmpty) {
        entriesList = GetMethods().getEntriesList(entries);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print('Rebuild entryList.dart');

    return BlocProvider(
      create: (context) =>
          TaskBloc(RepositoryProvider.of<TaskRepository>(context))
            ..add(TaskLoading()),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: entriesList.length,
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
                          entriesList[index].type?['name'] ??
                              "Failed to get type",
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
          // SizedBox(
          //   height: 300,
          //   width: double.infinity,
          //   child: ListView.builder(itemBuilder: (context, index) {
          //     return Text(
          //       entriesList[index].type?.name ?? "stuff",
          //       style: TextStyle(color: Colors.white),
          //     );
          //   }),
          // )
        ],
      ),
    );
  }
}
