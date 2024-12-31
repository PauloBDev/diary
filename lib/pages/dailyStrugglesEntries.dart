import 'dart:async';
import 'dart:convert';

import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/dailyType_model.dart';
import 'package:diary/models/task_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DailyStrugglesEntries extends StatefulWidget {
  const DailyStrugglesEntries({super.key});

  @override
  State<DailyStrugglesEntries> createState() => _DailyStrugglesEntriesState();
}

class _DailyStrugglesEntriesState extends State<DailyStrugglesEntries> {
  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _dailyStruggles;
  late StreamSubscription _dailyTypes;

  List<DailyEntry> entryList = [];

  bool hasTypes = false;

  DailyEntry defaultDailyEntry = DailyEntry(
      type: Type.stomach, scale: '', timeStamp: DateTime.now().toString());
  DailyType defaultDailyType = DailyType(
    name: '',
    icon: '',
  );

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    _dailyStruggles.cancel();
    super.deactivate();
  }

  void _activateListeners() {
    _dailyStruggles = _database
        .child(
            'dailyStruggles/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}')
        .onValue
        .listen((event) {
      final struggle = event.snapshot.value.toString();

      if (struggle.isNotEmpty) entryList = getStrugglesList(struggle);

      for (var struggle in entryList) {
        print(
            '${struggle.scale} - ${struggle.type.name} - ${struggle.timeStamp}');
      }

      setState(() {});
    });

    _dailyTypes = _database.child('dailyTypes/').onValue.listen((event) {
      final types = event.snapshot.value.toString();

      if (types.isNotEmpty) {
        setState(() {
          hasTypes = true;
        });
      }
    });
  }

  void dropDownCallBackType(String? selectedType) {
    if (selectedType is String) {
      setState(() {});
    }
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
          child: hasTypes == true
              ? Column(
                  children: [
                    GestureDetector(
                      onTap: () => _showEntryDialog(defaultDailyEntry),
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
                      itemCount: entryList.length,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      border: Border.all(color: Colors.white)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.wrong_location),
                                      Flexible(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * 0.35,
                                              child: Text(
                                                entryList[index].type.name ??
                                                    'Failed to get task name',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                height: 80.0,
                                                width: double.infinity,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    Positioned.fill(
                                                      child:
                                                          LinearProgressIndicator(
                                                        //Here you pass the percentage
                                                        value: 0.7,
                                                        color: Colors.blue
                                                            .withAlpha(100),
                                                        backgroundColor: Colors
                                                            .blue
                                                            .withAlpha(50),
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(children: [
                        Center(
                          child: Text(
                            'You have not created a type',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(
                            'So you can keep track of your struggles, please provide a type of the struggle you are feeling.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(
                            'All you have to do is press on the button bellow and give a name and an icon of your choosing',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () => _showTypeDialog(defaultDailyType),
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: const Text(
                              "Create a type.",
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
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'To add an entry, all you have to do is create a type and then you can create it!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _showEntryDialog(DailyEntry defaultDailyEntry) {
    print('Build Dialog');
    final addDailyEntry = _database.child('dailyStruggles/');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Center(
            child: Text(
          "Add an entry",
          style: TextStyle(color: Colors.white),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Type',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownButton(
              items: [],
              onChanged: (value) {},
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final newRefAddTask = addDailyEntry.push();

                await newRefAddTask.set({
                  "type": Type.stomach,
                  "scale": '',
                  "timeStamp": DateTime.now().toString()
                });
              },
              child: Text('Confirm')),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      ),
    );
  }

  _showTypeDialog(DailyType defaultDailyType) {
    print('Build Dialog');
    final addDailyType = _database.child('dailyType/');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: const Center(
            child: Text(
          "Create a Type",
          style: TextStyle(color: Colors.white),
        )),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Type Name',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Icon',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            DropdownButton(
              items: [],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final newRefAddType = addDailyType.push();

                await newRefAddType.set({
                  "name": '',
                  "icon": '',
                });
              },
              child: Text('Confirm')),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      ),
    );
  }

  List<DailyEntry> getStrugglesList(String struggles) {
    final List<String> struggleStringList = [];
    final List<DailyEntry> strugglesList = [];

    final jsonString = struggles
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
          struggleStringList.add('{${test[0].replaceAll('"}"}', '"}')}');
        } else {
          struggleStringList.add('{${test[0]}}');
        }
      }
    }

    for (var struggles in struggleStringList) {
      final model = DailyEntry.fromJson(jsonDecode(
          struggles.replaceAll('":" ', '":"').replaceAll('"," ', '","')));
      strugglesList.add(model);
    }

    strugglesList.sort((a, b) {
      return a.timeStamp!.compareTo(b.timeStamp!);
    });

    return strugglesList;
  }
}
