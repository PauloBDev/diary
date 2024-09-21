import 'package:diary/bloc/to_do_list_bloc.dart';
import 'package:diary/to_do_list_page.dart';
import 'package:diary/widgets/clock_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ToDoListBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0x00005073),
              surface: const Color(0x0000415e)),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Diary', time: DateTime.now()),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.time});
  final String title;
  final DateTime time;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 10,
        shadowColor: Colors.black,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          const ClockWidget(optionTime: TimeOption.time)
        ]),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      'Control your life!',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
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
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 500,
              child: const Center(
                child: Text('GRAPH HERE'),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ToDoListPage(
                          title: widget.title,
                          time: widget.time,
                        ))),
                child: const Card(
                  child: SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                      child: Text(
                        "Check your To-DO's",
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
