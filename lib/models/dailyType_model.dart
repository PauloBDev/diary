class DailyType {
  String? name;
  String? icon;
  String? id;

  DailyType({
    required this.name,
    required this.icon,
    required this.id,
  });

  DailyType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['id'] = id;
    return data;
  }
}
