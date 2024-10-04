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
    on<TodoLoading>(_todoLoading);
    on<RemoveTodo>(_removeTodo);
    on<AddTodo>(_addTodo);
    on<EditTodo>(_editTodo);
  }

  _todoLoading(TodoLoading event, Emitter<TodoState> emit) async {
    emit(TodoLoadingState());
    try {
      final todos = await _todoRepository.getToDos();

      emit(TodoFetchedState(todos));
    } catch (e) {
      emit(TodoErrorState(e.toString()));
    }
  }

  _removeTodo(RemoveTodo event, Emitter<TodoState> emit) {
    emit(TodoLoadingState());
    try {
      print(event.todo.toJson());

      final todosRemoval =
          _todoRepository.removeTodo(event.todo.id, event.todos);
      emit(TodoFetchedState(todosRemoval));
    } catch (e) {
      emit(TodoErrorState(e.toString()));
    }
  }

  _addTodo(AddTodo event, Emitter<TodoState> emit) {
    emit(TodoLoadingState());
    try {
      print(event.todo.toJson());

      var todoAdded = _todoRepository.addTodo(event.todo, event.todos);

      emit(TodoFetchedState(todoAdded));
    } catch (e) {
      emit(TodoErrorState(e.toString()));
    }
  }

  _editTodo(EditTodo event, Emitter<TodoState> emit) {
    emit(TodoLoadingState());
    try {
      print(event.todos[event.index].toJson());

      var todoEdited = _todoRepository.editTodo(event.index, event.todos);

      emit(TodoFetchedState(todoEdited));
    } catch (e) {
      emit(TodoErrorState(e.toString()));
    }
  }
}
