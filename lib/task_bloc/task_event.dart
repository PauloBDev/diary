part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskLoading extends TaskEvent {}

class AddTask extends TaskEvent {
  final DailyEntry task;
  final List<DailyEntry> tasks;

  const AddTask(this.task, this.tasks);

  @override
  List<Object?> get props => [task, tasks];
}

class RemoveTask extends TaskEvent {
  final List<DailyEntry> tasks;
  final DailyEntry task;

  const RemoveTask(this.task, this.tasks);

  @override
  List<Object?> get props => [task, tasks];
}

class EditTask extends TaskEvent {
  final int index;
  final List<DailyEntry> tasks;

  const EditTask(this.index, this.tasks);

  @override
  List<Object?> get props => [index, tasks];
}
