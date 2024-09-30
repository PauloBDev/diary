import 'dart:convert';

class ToDos {
  List<Todo> todos;

  ToDos({
    required this.todos,
  });

  factory ToDos.fromRawJson(String str) => ToDos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ToDos.fromJson(Map<String, dynamic> json) => ToDos(
        todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
      };
}

class Todo {
  int id;
  String todo;
  bool completed;
  int userId;

  Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory Todo.fromRawJson(String str) => Todo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "completed": completed,
        "userId": userId,
      };
}
