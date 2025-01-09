import 'dart:async';
import 'dart:ffi';

import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/dailyType_model.dart';
import 'package:diary/repositories/simpleMethods.dart';
import 'package:diary/widgets/daily_entries.dart';
import 'package:diary/widgets/removeTypeDialog.dart';
import 'package:diary/widgets/scaleBarEntries.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog({
    super.key,
    required this.editEntry,
    this.scaleEdit,
    this.selectedTypeEdit,
    this.entryId,
    this.permanentEdit,
    required this.typeListNotifier,
  });

  final bool editEntry;
  final int? scaleEdit;
  final Map<String, dynamic>? selectedTypeEdit;
  final String? entryId;
  final String? permanentEdit;
  final ValueNotifier<List<DailyType>> typeListNotifier;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailyTypes;
  late StreamSubscription _dailyEntriesPermanent;
  late StreamSubscription _dailyEntries;
  bool tempPermanentIconShake = false;

  List<DailyEntry> entryListPermanent = [];
  List<DailyEntry> entryList = [];

  final ValueNotifier<bool> permanentIconShake = ValueNotifier<bool>(false);

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
    print("Entry Dialog listeners");
    List<DailyType> newListInnit = [];

    selectedScale.value = widget.scaleEdit ?? 0;

    tempPermanentIconShake = widget.permanentEdit == "true" ? true : false;

    permanentIconShake.value = tempPermanentIconShake;

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
        widget.typeListNotifier.value = GetMethods().getTypesList(types);
      }

      newListInnit = widget.typeListNotifier.value.toList();

      if (widget.selectedTypeEdit != null) {
        newListInnit[newListInnit.indexWhere(
                (type) => type.id == widget.selectedTypeEdit?['id'])]
            .selected = "true";
      }

      List<DailyType> tempList = [];

      for (var type in newListInnit) {
        bool conditionOne = false;
        bool conditionTwo = false;

        for (var entry in entryList) {
          if (entry.type!.containsValue(type.id)) {
            conditionOne = true;
          }
        }

        for (var entry in entryListPermanent) {
          if (entry.type!.containsValue(type.id)) {
            conditionTwo = true;
          }
        }

        if (conditionOne || conditionTwo) {
          if (newListInnit
              .where((typeInnit) =>
                  typeInnit.id == type.id &&
                  typeInnit.id != widget.selectedTypeEdit!['id'])
              .isNotEmpty) {
            tempList.add(newListInnit
                .where((typeInnit) =>
                    typeInnit.id == type.id &&
                    typeInnit.id != widget.selectedTypeEdit!['id'])
                .first);
          }

          conditionOne = false;
          conditionTwo = false;
        }
      }

      newListInnit.removeWhere((type) => tempList.contains(type));

      widget.typeListNotifier.value = newListInnit;
    });

    setState(() {});
  }

  DailyType? selectedType;
  final ValueNotifier<int> selectedScale = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    print('Build Dialog');

    return AlertDialog(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            32.0,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      title: Center(
          child: Text(
        widget.editEntry == true ? "Edit the entry" : "Add an entry",
        style: const TextStyle(color: Colors.white),
      )),
      content: ValueListenableBuilder<List<DailyType>>(
        builder: (BuildContext context, List<DailyType> value, Widget? child) {
          return Column(
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
              Container(
                height: 30,
                width: double.maxFinite,
                margin: const EdgeInsets.only(right: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.typeListNotifier.value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => RemoveTypeDialog(
                          type: widget.typeListNotifier.value[index],
                        ),
                      ),
                      onTap: () {
                        final newList = widget.typeListNotifier.value.toList();
                        for (var type in newList) {
                          if (type.selected == "true" &&
                              newList[index].id != type.id) {
                            type.selected = "false";
                          }
                        }
                        newList[index].selected = "true";

                        selectedType = newList[index];

                        widget.typeListNotifier.value = newList;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color:
                              widget.typeListNotifier.value[index].selected ==
                                      "true"
                                  ? Colors.green
                                  : Colors.white,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                          child: Text(
                            '${widget.typeListNotifier.value[index].name}',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Scale',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 30,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedScale.value = index + 1;
                      },
                      child: ValueListenableBuilder(
                        builder: (context, value, child) {
                          return
                              // ScaleBarEntries(
                              //   scaleValue: widget.scaleEdit ?? 0,
                              //   editingValues: widget.editEntry,
                              //   index: index,
                              // );

                              Container(
                            width: 26.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(index == 0 ? 20 : 0),
                                  right: Radius.circular(index == 9 ? 20 : 0)),
                              color: selectedScale.value == 0
                                  ? Colors.white
                                  : selectedScale.value <= 3 &&
                                          index <= selectedScale.value - 1
                                      ? Colors.green
                                      : selectedScale.value <= 7 &&
                                              selectedScale.value >= 4 &&
                                              index <= selectedScale.value - 1
                                          ? Colors.yellow
                                          : selectedScale.value >= 8 &&
                                                  index <=
                                                      selectedScale.value - 1
                                              ? Colors.red
                                              : Colors.white,
                              border: const Border(
                                right: BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Center(child: Text('${index + 1}')),
                          );
                        },
                        valueListenable: selectedScale,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Want to make it permanent?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: ValueListenableBuilder<bool?>(
                    valueListenable: permanentIconShake,
                    builder:
                        (BuildContext context, bool? value, Widget? child) {
                      return GestureDetector(
                        onTap: () => permanentIconShake.value =
                            !permanentIconShake.value,
                        child: permanentIconShake.value == false
                            ? const Icon(
                                Icons.lock,
                                color: Colors.white,
                              )
                            : Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                      .animate(
                                        delay: 0.milliseconds,
                                      )
                                      .shake(
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                      ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Text(
                                    'Locked in!',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
        valueListenable: widget.typeListNotifier,
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Confirm')),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }

  void handleEntriesRequest() async {
    final dailyEntryPermanent = _database.child('dailyEntries/permanent');
    final dailyEntry = _database.child('dailyEntries/notPermanent');

    final newRefAddDailyEntryPermanent = dailyEntryPermanent.push();
    final newRefAddDailyEntry = dailyEntry.push();

    if (widget.editEntry == true) {
      if (tempPermanentIconShake == true && permanentIconShake.value == false) {
        dailyEntryPermanent.child('${widget.entryId}/').remove();

        selectedType != null
            ? await newRefAddDailyEntry.set(
                {
                  "type":
                      'a{icon: ${selectedType!.icon}, id: ${selectedType!.id}, name: ${selectedType!.name}, selected: ${selectedType!.selected}}',
                  "scale": selectedScale.value.toString(),
                  "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                  "id": newRefAddDailyEntry.key,
                  "permanent": permanentIconShake.value.toString(),
                  "showOnMain": "true",
                },
              )
            : await newRefAddDailyEntry.set(
                {
                  "type":
                      'a{icon: ${widget.selectedTypeEdit!['icon']}, id: ${widget.selectedTypeEdit!['id']}, name: ${widget.selectedTypeEdit!['name']}, selected: ${widget.selectedTypeEdit!['selected']}}',
                  "scale": selectedScale.value.toString(),
                  "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                  "id": newRefAddDailyEntry.key,
                  "permanent": permanentIconShake.value.toString(),
                  "showOnMain": "true",
                },
              );
      } else if (tempPermanentIconShake == false &&
          permanentIconShake.value == true) {
        dailyEntry.child('${widget.entryId}/').remove();

        selectedType != null
            ? await newRefAddDailyEntryPermanent.set(
                {
                  "type":
                      'a{icon: ${selectedType!.icon}, id: ${selectedType!.id}, name: ${selectedType!.name}, selected: ${selectedType!.selected}}',
                  "scale": selectedScale.value.toString(),
                  "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                  "id": newRefAddDailyEntryPermanent.key,
                  "permanent": permanentIconShake.value.toString(),
                  "showOnMain": "true",
                },
              )
            : await newRefAddDailyEntryPermanent.set(
                {
                  "type":
                      'a{icon: ${widget.selectedTypeEdit!['icon']}, id: ${widget.selectedTypeEdit!['id']}, name: ${widget.selectedTypeEdit!['name']}, selected: ${widget.selectedTypeEdit!['selected']}}',
                  "scale": selectedScale.value.toString(),
                  "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                  "id": newRefAddDailyEntryPermanent.key,
                  "permanent": permanentIconShake.value.toString(),
                  "showOnMain": "true",
                },
              );
      } else {
        if (tempPermanentIconShake == false &&
            permanentIconShake.value == false) {
          selectedType == null
              ? await dailyEntry.child('${widget.entryId}/').update({
                  "scale": selectedScale.value.toString(),
                  "permanent": permanentIconShake.value.toString(),
                })
              : await dailyEntry.child('${widget.entryId}/').update(
                  {
                    "type":
                        'a{icon: ${selectedType!.icon ?? widget.selectedTypeEdit?['icon']}, id: ${selectedType!.id ?? widget.selectedTypeEdit?['id']}, name: ${selectedType!.name ?? widget.selectedTypeEdit?['name']}, selected: ${selectedType!.selected ?? widget.selectedTypeEdit?['selected']}}',
                    "scale": selectedScale.value.toString(),
                    "permanent": permanentIconShake.value.toString(),
                  },
                );
        } else {
          selectedType == null
              ? await dailyEntryPermanent.child('${widget.entryId}/').update({
                  "scale": selectedScale.value.toString(),
                  "permanent": permanentIconShake.value.toString(),
                })
              : await dailyEntryPermanent.child('${widget.entryId}/').update(
                  {
                    "type":
                        'a{icon: ${selectedType!.icon ?? widget.selectedTypeEdit?['icon']}, id: ${selectedType!.id ?? widget.selectedTypeEdit?['id']}, name: ${selectedType!.name ?? widget.selectedTypeEdit?['name']}, selected: ${selectedType!.selected ?? widget.selectedTypeEdit?['selected']}}',
                    "scale": selectedScale.value.toString(),
                    "permanent": permanentIconShake.value.toString(),
                  },
                );
        }
      }
    } else {
      if (permanentIconShake.value == true) {
        await newRefAddDailyEntryPermanent.set(
          {
            "type":
                'a{icon: ${selectedType!.icon}, id: ${selectedType!.id}, name: ${selectedType!.name}, selected: ${selectedType!.selected}}',
            "scale": selectedScale.value.toString(),
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "id": newRefAddDailyEntryPermanent.key,
            "permanent": permanentIconShake.value.toString(),
            "showOnMain": "true",
          },
        );
      } else {
        await newRefAddDailyEntry.set(
          {
            "type":
                'a{icon: ${selectedType!.icon}, id: ${selectedType!.id}, name: ${selectedType!.name}, selected: ${selectedType!.selected}}',
            "scale": selectedScale.value.toString(),
            "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
            "id": newRefAddDailyEntry.key,
            "permanent": permanentIconShake.value.toString(),
            "showOnMain": "true",
          },
        );
      }
    }
  }
}
