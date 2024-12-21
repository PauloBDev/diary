enum Type { stomach, headache, eyes, mood, stress }

class DailyEntry {
  late Type type;
  String? scale;
  String? timeStamp;
  String? comment;

  DailyEntry(
      {required this.type,
      required this.scale,
      required this.timeStamp,
      this.comment});

  DailyEntry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    scale = json['scale'];
    timeStamp = json['timeStamp'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['scale'] = scale;
    data['timeStamp'] = timeStamp;
    data['comment'] = comment;
    return data;
  }
}
