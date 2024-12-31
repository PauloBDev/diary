enum Type { stomach, headache, eyes, mood, stress }

class DailyEntry {
  late Type type;
  String? scale;
  String? timeStamp;
  String? comment;
  String? id;

  DailyEntry({
    required this.type,
    required this.scale,
    required this.timeStamp,
    this.comment,
    required this.id,
  });

  DailyEntry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    scale = json['scale'];
    timeStamp = json['timeStamp'];
    comment = json['comment'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['scale'] = scale;
    data['timeStamp'] = timeStamp;
    data['comment'] = comment;
    data['id'] = id;
    return data;
  }
}
