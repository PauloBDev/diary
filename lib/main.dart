import 'package:diary/components/homepageTasksCard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0x00005073),
            surface: const Color(0x0000415e)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Diary', time: DateTime.now()),
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
          Text(
            '${widget.time.hour}-${widget.time.minute}-${widget.time.second}',
            style: const TextStyle(color: Colors.white),
          )
        ]),
      ),
      body: Column(
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
          Container(
            width: double.infinity,
            child: Card(child: Text('GRAPH HERE')),
          ),
          const HomePageCard()
        ],
      ),
    );
  }
}
