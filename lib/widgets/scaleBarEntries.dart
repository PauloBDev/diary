import 'package:flutter/material.dart';

class ScaleBarEntries extends StatelessWidget {
  const ScaleBarEntries(
      {super.key,
      required this.scaleValue,
      required this.editingValues,
      this.index});

  final int scaleValue;
  final bool editingValues;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return editingValues == true
        ? Container(
            width: 26.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(index == 0 ? 20 : 0),
                  right: Radius.circular(index == 9 ? 20 : 0)),
              color: scaleValue == 0
                  ? Colors.white
                  : scaleValue <= 3 && index! <= scaleValue - 1
                      ? Colors.green
                      : scaleValue <= 7 &&
                              scaleValue >= 4 &&
                              index! <= scaleValue - 1
                          ? Colors.yellow
                          : scaleValue >= 8 && index! <= scaleValue - 1
                              ? Colors.red
                              : Colors.white,
              border: const Border(
                right: BorderSide(color: Colors.black),
              ),
            ),
            child: Center(
              child: Text('${index! + 1}'),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, i) {
              return Container(
                width: 26.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(i == 0 ? 20 : 0),
                      right: Radius.circular(i == 9 ? 20 : 0)),
                  color: scaleValue == 0
                      ? Colors.white
                      : scaleValue <= 3 && i <= scaleValue - 1
                          ? Colors.green
                          : scaleValue <= 7 &&
                                  scaleValue >= 4 &&
                                  i <= scaleValue - 1
                              ? Colors.yellow
                              : scaleValue >= 8 && i <= scaleValue - 1
                                  ? Colors.red
                                  : Colors.white,
                  border: const Border(
                    right: BorderSide(color: Colors.black),
                  ),
                ),
                child: Center(
                  child: Text('${i + 1}'),
                ),
              );
            },
          );
  }
}
