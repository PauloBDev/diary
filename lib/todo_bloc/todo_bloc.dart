import 'package:diary/models/todo_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoInitialState()) {
    on<TodoLoading>((event, emit) async {
      emit(TodoLoadingState());
      try {
        final todos = await _todoRepository.getToDos();

        emit(TodoFetchedState(todos));
      } catch (e) {
        emit(TodoErrorState(e.toString()));
      }
    });
    on<RemoveTodo>((event, emit) {
      emit(TodoLoadingState());
      try {
        print(event.todos[0].todo);
        final todosRemoval =
            _todoRepository.removeTodo(event.todo.id, event.todos);
        emit(TodoFetchedState(todosRemoval));
      } catch (e) {
        emit(TodoErrorState(e.toString()));
      }
    });
  }
}
