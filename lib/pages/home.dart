import 'package:diary/models/todo_model.dart';
import 'package:diary/pages/toDoList.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/todo_bloc/todo_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.time});
  final String title;
  final DateTime time;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0.0,
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.settings)),
            )
          ],
        ),
        body: ToDoListWidget());
  }
}
