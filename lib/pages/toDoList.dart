import 'package:diary/models/todo_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:diary/todo_bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ToDoListWidget extends StatelessWidget {
  const ToDoListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    print('Rebuilded todolist.dart');

    return BlocProvider(
      create: (context) =>
          TodoBloc(RepositoryProvider.of<TodoRepository>(context))
            ..add(TodoLoading()),
      child: Column(
        children: [
          SizedBox(
            height: 250,
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoFetchedState && state.todos.isNotEmpty) {
                  List<Todo> todoList = state.todos;
                  print('Rebuilded FetchedState');

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
                                        context
                                            .read<TodoBloc>()
                                            .add(EditTodo(index, state.todos));
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
                                        context.read<TodoBloc>().add(RemoveTodo(
                                            state.todos[index], state.todos));
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
                  print('Rebuilded LoadingState');
                  return Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is TodoErrorState) {
                  print('Rebuilded ErrorState');
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
                  print('Rebuilded ListEmptyState');
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
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                focusColor: Colors.black87,
                splashColor: Colors.black87,
                foregroundColor: Colors.black87,
                onPressed: () => _addTodoDialog(context),
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
    );
  }

  Future<void> _addTodoDialog(BuildContext context) {
    // final todoController = TextEditingController();

    return showGeneralDialog(
      barrierLabel: "showGeneralDialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 500,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black87),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade400,
                border:
                    Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  Center(
                    child: DefaultTextStyle(
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32,
                          color: Colors.grey.shade300),
                      child: const Text('Add a Todo!'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // SizedBox(
                  //   width: 300,
                  //   child: Column(
                  //     children: [
                  //       TextField(
                  //         controller: todoController,
                  //         decoration: const InputDecoration(labelText: 'email'),
                  //       ),
                  //       const Spacer(),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           TextButton(
                  //             onPressed: () {},
                  //             child: const Text('Confirm'),
                  //           ),
                  //           TextButton(
                  //             onPressed: () => Navigator.pop(context),
                  //             child: const Text('Cancel'),
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
