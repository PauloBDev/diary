class DailyType {
  String? name;
  String? icon;

  DailyType({
    required this.name,
    required this.icon,
  });

  DailyType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['scale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    return data;
  }
}
