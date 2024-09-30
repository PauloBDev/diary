import 'dart:convert';

import 'package:diary/models/todo_model.dart';
import 'package:http/http.dart';

class TodoRepository {
  String endpoint = 'https://dummyjson.com/todos';
  Future<List<Todo>> getToDos() async {
    Response response = await get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['todos'];

      return result.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  List<Todo> removeTodo(int id, List<Todo> todos) {
    todos.removeWhere((element) => element.id == id);
    return todos;
  }
}
