import 'package:diary/models/dailyType_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class RemoveTypeDialog extends StatefulWidget {
  const RemoveTypeDialog({super.key, required this.type});

  final DailyType type;

  @override
  State<RemoveTypeDialog> createState() => _RemoveTypeDialogState();
}

class _RemoveTypeDialogState extends State<RemoveTypeDialog> {
  TextEditingController typeName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _database = FirebaseDatabase.instance.ref();

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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              "Are you sure you want to delete the type:",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "${widget.type.name}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              final removeDailyType =
                  _database.child('dailyType/${widget.type.id}');

              await removeDailyType.remove();

              Navigator.pop(context);
            },
            child: const Text('Confirm')),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
  }
}
