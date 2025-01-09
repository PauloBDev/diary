import 'dart:async';
import 'dart:convert';

import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/dailyType_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/repositories/simpleMethods.dart';
import 'package:diary/task_bloc/task_bloc.dart';
import 'package:diary/widgets/entryDialog.dart';
import 'package:diary/widgets/entryListNotPermanent.dart';
import 'package:diary/widgets/entryListPermanent.dart';
import 'package:diary/widgets/noTypeEntryPage.dart';
import 'package:diary/widgets/scaleBarEntries.dart';
import 'package:diary/widgets/typeDialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class DailyStrugglesEntries extends StatefulWidget {
  const DailyStrugglesEntries({super.key});

  @override
  State<DailyStrugglesEntries> createState() => _DailyStrugglesEntriesState();
}

class _DailyStrugglesEntriesState extends State<DailyStrugglesEntries> {
  final _database = FirebaseDatabase.instance.ref();

  late StreamSubscription _dailyEntriesPermanent;

  late StreamSubscription _dailyEntries;

  late StreamSubscription _dailyTypes;

  final ValueNotifier<bool?> hasTypes = ValueNotifier<bool?>(null);

  final ValueNotifier<List<DailyType>> typeListNotifier =
      ValueNotifier<List<DailyType>>([]);

  List<DailyEntry> entryListPermanent = [];

  List<DailyEntry> entryList = [];

  DailyEntry defaultDailyEntry = DailyEntry(
    type: null,
    scale: '',
    timeStamp: DateTime.now().toString(),
    id: null,
    permanent: "false",
    showOnMain: "false",
  );

  DailyType defaultDailyType =
      DailyType(name: '', icon: null, id: null, selected: "false");

  final ValueNotifier<Icon?> _icon = ValueNotifier<Icon?>(null);

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  void deactivate() {
    _dailyEntriesPermanent.cancel();
    _dailyEntries.cancel();
    _dailyTypes.cancel();
    super.deactivate();
  }

  void _activateListeners() {
    print("Daily Entries listeners");
    _dailyEntriesPermanent =
        _database.child('dailyEntries/permanent').onValue.listen((event) {
      final struggle = event.snapshot.value.toString();

      if (struggle.isNotEmpty) {
        entryListPermanent = GetMethods().getEntriesList(struggle);
      }
    });

    _dailyEntries =
        _database.child('dailyEntries/notPermanent').onValue.listen((event) {
      final struggle = event.snapshot.value.toString();

      if (struggle.isNotEmpty) {
        entryList = GetMethods().getEntriesList(struggle);
      }
    });

    _dailyTypes = _database.child('dailyTypes/').onValue.listen((event) {
      final types = event.snapshot.value.toString();

      if (types.isNotEmpty && types != "null") {
        hasTypes.value = true;

        typeListNotifier.value = GetMethods().getTypesList(types);
      } else {
        hasTypes.value = false;
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskBloc(RepositoryProvider.of<TaskRepository>(context))
            ..add(TaskLoading()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
        body: ValueListenableBuilder<bool?>(
          valueListenable: hasTypes,
          builder: (BuildContext context, bool? value, Widget? child) {
            return hasTypes.value == true && hasTypes.value != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EntryDialog(
                                      editEntry: false,
                                      typeListNotifier: typeListNotifier,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
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
                              GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => TypeDialog(
                                    icon: _icon,
                                    editing: false,
                                  ),
                                ),
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: const Text(
                                    "Add a type.",
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ValueListenableBuilder(
                          valueListenable: typeListNotifier,
                          builder: (BuildContext context, List<DailyType> value,
                              Widget? child) {
                            return EntryListPermanent(
                              entryListPermanent: entryListPermanent,
                              typeListNotifier: typeListNotifier,
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: typeListNotifier,
                          builder: (BuildContext context, List<DailyType> value,
                              Widget? child) {
                            return EntryListNotPermanent(
                              entryList: entryList,
                              typeListNotifier: typeListNotifier,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                : hasTypes.value == false && hasTypes.value != null
                    ? NoTypeEntryPage(icon: _icon)
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
          },
        ),
      ),
    );
  }
}
