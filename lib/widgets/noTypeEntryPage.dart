import 'package:diary/widgets/typeDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NoTypeEntryPage extends StatelessWidget {
  const NoTypeEntryPage({super.key, required this.icon});

  final ValueNotifier<Icon?> icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: const Column(children: [
            Center(
              child: Text(
                'You have not created a type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                'So you can keep track of your struggles, please provide a type of the struggle you are feeling.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Center(
              child: Text(
                'All you have to do is press on the button bellow and give a name and an icon of your choosing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ]),
        ),
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (context) => TypeDialog(
              icon: icon,
              editing: false,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            width: double.infinity,
            height: 50,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Text(
                  "Create a type.",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  .animate(
                delay: 0.milliseconds,
                onPlay: (controller) => controller.repeat(),
              )
                  .shimmer(colors: [
                Colors.green,
                Colors.red,
                Colors.green,
              ], duration: 3000.milliseconds),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Column(
            children: [
              Center(
                child: Text(
                  'To add an entry, all you have to do is create a type and then you can create it!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
