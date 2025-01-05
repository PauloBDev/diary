import 'package:flutter/material.dart';

class DailyType {
  String? name;
  String? icon;
  String? id;
  String? selected;

  DailyType({
    required this.name,
    required this.icon,
    required this.id,
    required this.selected,
  });

  DailyType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    id = json['id'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['icon'] = icon;
    data['id'] = id;
    data['selected'] = selected;
    return data;
  }
}
