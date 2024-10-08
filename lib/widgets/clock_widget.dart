import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TimeOption { date, time, all }

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key, required this.optionTime});
  final TimeOption optionTime;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Text(
          DateFormat(optionTime == TimeOption.date
                  ? 'MM/dd/yyyy'
                  : optionTime == TimeOption.time
                      ? 'hh:mm'
                      : 'MM/dd/yyyy hh:mm')
              .format(DateTime.now()),
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}
