import 'dart:async';
import 'dart:ffi';

import 'package:diary/models/dailyType_model.dart';
import 'package:diary/repositories/simpleMethods.dart';
import 'package:diary/widgets/removeTypeDialog.dart';
import 'package:diary/widgets/scaleBarEntries.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EntryDialog extends StatefulWidget {
  const EntryDialog(
      {super.key,
      required this.editEntry,
      this.scaleEdit,
      this.selectedTypeEdit,
      this.entryId});

  final bool editEntry;
  final int? scaleEdit;
  final Map<String, dynamic>? selectedTypeEdit;
  final String? entryId;

  @override
  State<EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<EntryDialog> {
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dailyTypes;

  final ValueNotifier<List<DailyType>> typeListNotifier =
      ValueNotifier<List<DailyType>>([]);

  @override
  void initState() {
    super.initState();
    debugPrint('selectedTypeEdit: ${widget.selectedTypeEdit}');

    _activateListeners();
  }

  void _activateListeners() {
    List<DailyType> newListInnit = [];

    selectedScale.value = widget.scaleEdit ?? 0;

    _dailyTypes = _database.child('dailyTypes/').onValue.listen((event) {
      final types = event.snapshot.value.toString();

      if (types.isNotEmpty && types != "null") {
        typeListNotifier.value = GetMethods().getTypesList(types);
      }
      newListInnit = typeListNotifier.value.toList();
      if (widget.selectedTypeEdit != null) {
        newListInnit[newListInnit.indexWhere(
                (type) => type.id == widget.selectedTypeEdit?['id'])]
            .selected = "true";
      }
      debugPrint('${newListInnit.first}');
      typeListNotifier.value = newListInnit;
    });
  }

  DailyType? selectedType;
  final ValueNotifier<int> selectedScale = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    print('Build Dialog');
    final dailyEntry = _database.child('dailyEntries/');

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
          Container(
            height: 30,
            width: double.maxFinite,
            margin: const EdgeInsets.only(right: 8),
            child: ValueListenableBuilder<List<DailyType>>(
              builder:
                  (BuildContext context, List<DailyType> value, Widget? child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: typeListNotifier.value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => RemoveTypeDialog(
                          type: typeListNotifier.value[index],
                        ),
                      ),
                      onTap: () {
                        final newList = typeListNotifier.value.toList();
                        for (var type in newList) {
                          print("${type.name} - ${type.selected}");
                          if (type.selected == "true" &&
                              newList[index].id != type.id) {
                            type.selected = "false";
                          }

                          print("${type.name} - ${type.selected}");
                        }
                        newList[index].selected = "true";

                        selectedType = newList[index];

                        typeListNotifier.value = newList;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color:
                              typeListNotifier.value[index].selected == "true"
                                  ? Colors.green
                                  : Colors.white,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                          child: Text(
                            '${typeListNotifier.value[index].name}',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              valueListenable: typeListNotifier,
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
                                              index <= selectedScale.value - 1
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
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              final newRefAddDailyEntry = dailyEntry.push();
              print("${widget.entryId} - ${widget.selectedTypeEdit?['name']}");
              dailyEntry.child('${widget.selectedTypeEdit?['id']}/');

              if (widget.editEntry == true) {
                await dailyEntry.child('${widget.entryId}/').update({
                  "type":
                      'a{icon: ${selectedType!.icon ?? widget.selectedTypeEdit?['icon']}, id: ${selectedType!.id ?? widget.selectedTypeEdit?['id']}, name: ${selectedType!.name ?? widget.selectedTypeEdit?['name']}, selected: ${selectedType!.selected ?? widget.selectedTypeEdit?['selected']}}',
                  "scale": selectedScale.value.toString(),
                });
              } else {
                await newRefAddDailyEntry.set({
                  "type":
                      'a{icon: ${selectedType!.icon}, id: ${selectedType!.id}, name: ${selectedType!.name}, selected: ${selectedType!.selected}}',
                  "scale": selectedScale.value.toString(),
                  "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
                  "id": newRefAddDailyEntry.key,
                });
              }

              Navigator.pop(context);
            },
            child: const Text('Confirm')),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }
}
