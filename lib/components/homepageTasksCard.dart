import 'package:flutter/material.dart';

class HomePageCard extends StatelessWidget {
  const HomePageCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value) {},
          ),
          const Text('stuff')
        ],
      ),
    );
  }
}
