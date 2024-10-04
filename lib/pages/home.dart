import 'package:diary/pages/toDoList.dart';
import 'package:flutter/material.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    print('Rebuilded home.dart');

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
        body: Container(
            height: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        'Control your life!',
                        style: TextStyle(
                            fontSize: screenWidth * 0.08, color: Colors.white),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: const Icon(Icons.refresh_rounded)),
                      ),
                    )
                  ],
                ),
                const ToDoListWidget(),
              ],
            )));
  }
}
