import 'package:diary/models/dailyEntry_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class TypeDialog extends StatefulWidget {
  const TypeDialog(
      {super.key, required this.icon, required this.editing, this.entry});

  final ValueNotifier<Icon?> icon;
  final bool editing;
  final DailyEntry? entry;

  @override
  State<TypeDialog> createState() => _TypeDialogState();
}

class _TypeDialogState extends State<TypeDialog> {
  TextEditingController typeName = TextEditingController();

  @override
  void initState() {
    widget.icon.value = null;
    super.initState();
  }

  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: const SinglePickerConfiguration(
        iconColor: Colors.white,
        backgroundColor: Colors.black,
        iconPackModes: [
          IconPack.cupertino,
          IconPack.material,
          IconPack.allMaterial,
          IconPack.fontAwesomeIcons,
          IconPack.lineAwesomeIcons
        ],
      ),
    );

    return Icon(icon!.data);
  }

  @override
  Widget build(BuildContext context) {
    final _database = FirebaseDatabase.instance.ref();
    final addDailyType = _database.child('dailyTypes/');
    widget.icon.value = null;
    return AlertDialog(
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
      backgroundColor: Colors.black,
      title: const Center(
          child: Text(
        "Create a Type",
        style: TextStyle(color: Colors.white),
      )),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Type Name',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: typeName,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
                onPressed: () async {
                  widget.icon.value = await _pickIcon();
                },
                child: const Text('Select the icon you want')),
            ValueListenableBuilder<Icon?>(
              builder: (BuildContext context, Icon? value, Widget? child) {
                return widget.icon.value != null
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: value,
                        ),
                      )
                    : const SizedBox();
              },
              valueListenable: widget.icon,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              print('stuff: ${widget.icon}');
              final newRefAddType = addDailyType.push();
              print(widget.icon.toString());

              await newRefAddType.set({
                "name": typeName.text,
                "icon": widget.icon.value?.icon.toString(),
                "id": newRefAddType.key,
                "selected": "false",
              });

              Navigator.pop(context);
            },
            child: const Text('Confirm')),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }
}
