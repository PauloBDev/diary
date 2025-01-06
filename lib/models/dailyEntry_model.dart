import 'package:diary/models/dailyType_model.dart';

class DailyEntry {
  Map<String, dynamic>? type;
  String? scale;
  String? timeStamp;
  String? comment;
  String? id;
  String? permanent;
  String? showOnMain;

  DailyEntry({
    required this.type,
    required this.scale,
    required this.timeStamp,
    this.comment,
    required this.id,
    required this.permanent,
    required this.showOnMain,
  });

  DailyEntry.fromJson(Map<String, dynamic> json, Map<String, dynamic> typeMap) {
    type = {
      "icon": typeMap['icon'],
      "id": typeMap['id'],
      "name": typeMap['name'],
      "selected": typeMap['selected']
    };
    scale = json['scale'];
    timeStamp = json['timeStamp'];
    comment = json['comment'];
    id = json['id'];
    permanent = json['permanent'];
    showOnMain = json['showOnMain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['scale'] = scale;
    data['timeStamp'] = timeStamp;
    data['comment'] = comment;
    data['id'] = id;
    data['permanent'] = permanent;
    data['showOnMain'] = showOnMain;
    return data;
  }
}
