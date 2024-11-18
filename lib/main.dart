import 'package:diary/pages/home.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diary',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0x00005073),
              surface: const Color(0x0000415e)),
          useMaterial3: true,
          fontFamily: 'Poppins'),
      home: FutureBuilder(
          future: _fbApp,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              print('Error! ${snapshot.error.toString()}');
              return const Text('Error!');
            } else if (snapshot.hasData) {
              print('Successful!!');
              return RepositoryProvider(
                create: (context) => TaskRepository(),
                child: MyHomePage(title: 'Diary', time: DateTime.now()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
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
