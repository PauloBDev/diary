import 'package:diary/bloc/to_do_list_bloc.dart';
import 'package:diary/pages/home.dart';
import 'package:diary/pages/toDoList.dart';
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
            fontFamily: 'Poppins'),
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
    return HomePage(title: widget.title, time: widget.time);
  }
}
