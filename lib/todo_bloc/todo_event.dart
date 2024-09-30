part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class TodoLoading extends TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class RemoveTodo extends TodoEvent {
  final List<Todo> todos;
  final Todo todo;

  const RemoveTodo(this.todo, this.todos);

  @override
  List<Object?> get props => [todo, todos];
}

class EditTodo extends TodoEvent {
  final int index;

  const EditTodo(this.index);

  @override
  List<Object?> get props => [index];
}
