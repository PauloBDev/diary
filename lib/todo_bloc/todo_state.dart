part of 'todo_bloc.dart';

enum TodoStatus { initial, loading, success, error }

@immutable
abstract class TodoState extends Equatable {}

class TodoInitialState extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoLoadingState extends TodoState {
  @override
  List<Object?> get props => [];
}

class TodoFetchedState extends TodoState {
  TodoFetchedState(this.todos);
  final List<Todo> todos;

  @override
  List<Object?> get props => [todos];
}

class TodoErrorState extends TodoState {
  TodoErrorState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
