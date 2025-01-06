import 'package:diary/models/task_model.dart';
import 'package:diary/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part '../task_bloc/task_event.dart';
part '../task_bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;

  TaskBloc(this._taskRepository) : super(TaskInitialState()) {
    on<TaskLoading>(_taskLoading);
    on<RemoveTask>(_removeTask);
    on<AddTask>(_addTask);
    on<EditTask>(_editTask);
  }

  _taskLoading(TaskLoading event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    try {
      final tasks = await _taskRepository.getTasks();
      List<DailyTask> tasksOnlyFour = [];

      for (var i = 0; i < 4; i++) {
        tasksOnlyFour.add(tasks[i]);
      }

      emit(TaskFetchedState(tasksOnlyFour));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  _removeTask(RemoveTask event, Emitter<TaskState> emit) {
    emit(TaskLoadingState());
    try {
      final tasksRemoval =
          _taskRepository.removeTask(event.task.id, event.tasks);
      emit(TaskFetchedState(tasksRemoval));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  _addTask(AddTask event, Emitter<TaskState> emit) {
    emit(TaskLoadingState());
    try {
      var taskAdded = _taskRepository.addTask(event.task, event.tasks);

      emit(TaskFetchedState(taskAdded));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  _editTask(EditTask event, Emitter<TaskState> emit) {
    emit(TaskLoadingState());
    try {
      var taskEdited = _taskRepository.editTask(event.index, event.tasks);

      emit(TaskFetchedState(taskEdited));
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }
}
