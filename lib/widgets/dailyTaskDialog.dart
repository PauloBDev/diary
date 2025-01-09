import 'package:customizable_datetime_picker/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DailyTaskDialog extends StatelessWidget {
  const DailyTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController taskName = TextEditingController();
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    DateTime timePermanent = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);

    final ValueNotifier<bool> permanentIconShake = ValueNotifier<bool>(false);

    return AlertDialog(
      backgroundColor: Colors.black,
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
      title: const Center(
        child: Text(
          "Add a Task",
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Name of the task',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            controller: taskName,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 16,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Want to make it permanent?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: ValueListenableBuilder<bool?>(
                valueListenable: permanentIconShake,
                builder: (BuildContext context, bool? value, Widget? child) {
                  return GestureDetector(
                    onTap: () =>
                        permanentIconShake.value = !permanentIconShake.value,
                    child: permanentIconShake.value == false
                        ? const Icon(
                            Icons.lock,
                            color: Colors.white,
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.lock,
                                color: Colors.red,
                                size: 30,
                              )
                                  .animate(
                                    delay: 0.milliseconds,
                                  )
                                  .shake(
                                    duration: const Duration(
                                      milliseconds: 1000,
                                    ),
                                  ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Text(
                                'Locked in!',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ValueListenableBuilder<bool?>(
            valueListenable: permanentIconShake,
            builder: (BuildContext context, bool? value, Widget? child) {
              return permanentIconShake.value == true
                  ? Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'When is this task being done today?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: CustomizableTimePickerWidget(
                            looping: true,
                            initialTime: timePermanent,
                            timeFormat: "HH:mm",
                            pickerTheme: const DateTimePickerTheme(
                              itemTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              backgroundColor: Colors.black,
                              itemHeight: 70,
                              pickerHeight: 150,
                              dividerTheme: DatePickerDividerTheme(
                                dividerColor: Color(0xFF00A962),
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            onChange: (time, selectedIndex) {
                              timePermanent = time;
                              print("TimePermanent: $timePermanent");
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Chose a date to be notified!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              CustomizableDatePickerWidget(
                                looping: true,
                                initialDate: date,
                                dateFormat: "dd-MMMM-yyyy",
                                pickerTheme: const DateTimePickerTheme(
                                  itemTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  backgroundColor: Colors.black,
                                  itemHeight: 30,
                                  pickerHeight: 125,
                                  dividerTheme: DatePickerDividerTheme(
                                    dividerColor: Color(0xFF00A962),
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ),
                                onChange: (dateTime, selectedIndex) {
                                  date = dateTime;
                                  print("Date: $date");
                                },
                              ),
                              // const Divider(
                              //   color: Colors.white,
                              //   height: 3,
                              // ),
                              CustomizableTimePickerWidget(
                                looping: true,
                                initialTime: time,
                                timeFormat: "HH:mm",
                                pickerTheme: const DateTimePickerTheme(
                                  itemTextStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  backgroundColor: Colors.black,
                                  itemHeight: 30,
                                  pickerHeight: 125,
                                  dividerTheme: DatePickerDividerTheme(
                                    dividerColor: Color(0xFF00A962),
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ),
                                onChange: (time, selectedIndex) {
                                  time = time;
                                  print("Time: $time");
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Confirm')),
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Close'))
      ],
    );
    ;
  }
}
