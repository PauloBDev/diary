import 'dart:convert';
import 'package:diary/models/todo_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ToDoListWidget extends StatelessWidget {
  const ToDoListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) =>
          TodoBloc(RepositoryProvider.of<TodoRepository>(context))
            ..add(TodoLoading()),
      child: Container(
        height: double.infinity,
        color: Colors.black87,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    'Control your life!',
                    style: TextStyle(
                        fontSize: screenWidth * 0.08, color: Colors.white),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Icon(Icons.refresh_rounded)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 250,
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoFetchedState && state.todos.length > 0) {
                    List<Todo> todoList = state.todos;

                    return Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.black87,
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: ListView.builder(
                              itemCount: todoList.length,
                              itemBuilder: ((
                                context,
                                index,
                              ) {
                                return Card(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: todoList[index].completed,
                                        onChanged: (value) {
                                          todoList[index].completed =
                                              !todoList[index].completed;
                                        },
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.65,
                                        child: Text(
                                          todoList[index].todo,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      GestureDetector(
                                        onDoubleTap: () {
                                          context.read<TodoBloc>().add(
                                              RemoveTodo(state.todos[index],
                                                  state.todos));
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is TodoLoadingState) {
                    return Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is TodoErrorState) {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black87),
                      child: const Center(
                        child: Text(
                          'Failed to get Todos',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black87),
                      child: const Center(
                        child: Text(
                          'Please add a Todo!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  focusColor: Colors.black87,
                  splashColor: Colors.black87,
                  foregroundColor: Colors.black87,
                  onPressed: () {},
                  backgroundColor: Colors.black87,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
