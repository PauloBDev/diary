class Task {
  String? timeStamp;
  String? taskName;
  bool completed = false;
  String? id;

  Task(
      {this.timeStamp,
      this.taskName,
      required this.completed,
      required this.id});

  Task.fromJson(Map<String, dynamic> json) {
    timeStamp = json['timeStamp'];
    taskName = json['taskName'];
    completed = json['completed'] == "false" ? false : true;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeStamp'] = timeStamp;
    data['taskName'] = taskName;
    // ignore: unrelated_type_equality_checks
    data['completed'] = completed == 'false' ? false : true;
    data['id'] = id;
    return data;
  }
}
