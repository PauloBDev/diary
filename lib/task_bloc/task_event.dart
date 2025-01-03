part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskEvent {}

class AddTask extends TaskEvent {
  final DailyTask task;
  final List<DailyTask> tasks;

  const AddTask(this.task, this.tasks);

  @override
  List<Object?> get props => [task, tasks];
}

class RemoveTask extends TaskEvent {
  final List<DailyTask> tasks;
  final DailyTask task;

  const RemoveTask(this.task, this.tasks);

  @override
  List<Object?> get props => [task, tasks];
}

class EditTask extends TaskEvent {
  final int index;
  final List<DailyTask> tasks;

  const EditTask(this.index, this.tasks);

  @override
  List<Object?> get props => [index, tasks];
}
