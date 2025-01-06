import 'dart:convert';

import 'package:diary/models/dailyEntry_model.dart';
import 'package:diary/models/dailyType_model.dart';
import 'package:diary/models/task_model.dart';

class GetMethods {
  List<DailyTask> getDailyTasks(String tasks) {
    final List<String> taskStringList = [];
    final List<DailyTask> taskList = [];

    final jsonString = tasks
        .replaceAll(RegExp(r'\+'), '') // To remove all white spaces
        .replaceAll(
            RegExp(r':'), '":"') // To add double-quotes on both sides of colon
        .replaceAll(
            RegExp(r','), '","') // To add double-quotes on both sides of comma
        .replaceAll(RegExp(r'{'),
            '{"') // To add double-quotes after every open curly bracket
        .replaceAll(RegExp(r'}'), '"}');

    final jsonSplitAllDynamicOut = jsonString.split('":" {');

    for (var i = 1; i < jsonSplitAllDynamicOut.length; i++) {
      final test = jsonSplitAllDynamicOut[i].split('}"," ');

      if (test.runtimeType != String) {
        if (test[0].contains('"}"}')) {
          taskStringList.add('{${test[0].replaceAll('"}"}', '"}')}');
        } else {
          taskStringList.add('{${test[0]}}');
        }
      }
    }

    for (var task in taskStringList) {
      final model = DailyTask.fromJson(
          jsonDecode(task.replaceAll('":" ', '":"').replaceAll('"," ', '","')));
      taskList.add(model);
    }

    taskList.sort((a, b) {
      return a.timeStamp!.compareTo(b.timeStamp!);
    });

    return taskList;
  }

  List<DailyEntry> getEntriesList(String struggles) {
    final List<String> struggleStringList = [];
    final List<DailyEntry> strugglesList = [];

    final jsonString = struggles
        .replaceAll(RegExp(r'\+'), '') // To remove all white spaces
        .replaceAll(
            RegExp(r':'), '":"') // To add double-quotes on both sides of colon
        .replaceAll(
            RegExp(r','), '","') // To add double-quotes on both sides of comma
        .replaceAll(RegExp(r'{'),
            '{"') // To add double-quotes after every open curly bracket
        .replaceAll(RegExp(r'}'), '"}');

    final jsonSplitAllDynamicOut = jsonString.split('":" {');

    for (var i = 1; i < jsonSplitAllDynamicOut.length; i++) {
      final test = jsonSplitAllDynamicOut[i].split('}"," ');

      if (test.runtimeType != String) {
        if (test[0].contains('"}"}')) {
          struggleStringList.add('{${test[0].replaceAll('"}"}', '"}')}');
        } else {
          struggleStringList.add('{${test[0]}}');
        }
      }
    }

    for (var struggles in struggleStringList) {
      final strugglesString = struggles
          .replaceAll('":" ', '":"')
          .replaceAll('"," ', '","')
          .replaceAll('","type":"a{', '","type":"aa{')
          .split('aa')[1];
      final model = DailyEntry.fromJson(
          jsonDecode(struggles
              .replaceAll('":" ', '":"')
              .replaceAll('"," ', '","')
              .replaceAll('","type":"a{', '"}aa')
              .split('aa"')[0]),
          jsonDecode(strugglesString.substring(0, strugglesString.length - 2)));

      strugglesList.add(model);
    }
    strugglesList.sort((a, b) {
      return a.type!['name']!.compareTo(b.type!['name']!);
    });

    return strugglesList;
  }

  List<DailyType> getTypesList(String types) {
    final List<String> typesStringList = [];
    final List<DailyType> typesList = [];

    final jsonString = types
        .replaceAll(RegExp(r'\+'), '') // To remove all white spaces
        .replaceAll(
            RegExp(r':'), '":"') // To add double-quotes on both sides of colon
        .replaceAll(
            RegExp(r','), '","') // To add double-quotes on both sides of comma
        .replaceAll(RegExp(r'{'),
            '{"') // To add double-quotes after every open curly bracket
        .replaceAll(RegExp(r'}'), '"}');

    final jsonSplitAllDynamicOut = jsonString.split('":" {');

    for (var i = 1; i < jsonSplitAllDynamicOut.length; i++) {
      final test = jsonSplitAllDynamicOut[i].split('}"," ');

      if (test.runtimeType != String) {
        if (test[0].contains('"}"}')) {
          typesStringList.add('{${test[0].replaceAll('"}"}', '"}')}');
        } else {
          typesStringList.add('{${test[0]}}');
        }
      }
    }

    for (var struggles in typesStringList) {
      final model = DailyType.fromJson(jsonDecode(
          struggles.replaceAll('":" ', '":"').replaceAll('"," ', '","')));
      typesList.add(model);
    }

    typesList.sort((a, b) {
      return a.name!.compareTo(b.name!);
    });

    return typesList;
  }
}
