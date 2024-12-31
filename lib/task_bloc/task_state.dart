part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, error }

@immutable
abstract class TaskState extends Equatable {}

class TaskInitialState extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskLoadingState extends TaskState {
  @override
  List<Object?> get props => [];
}

class TaskFetchedState extends TaskState {
  TaskFetchedState(this.tasks);
  final List<DailyTask> tasks;

  @override
  List<Object?> get props => [tasks];
}

class TaskErrorState extends TaskState {
  TaskErrorState(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
