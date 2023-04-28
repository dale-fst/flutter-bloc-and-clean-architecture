import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/data/repository/task_repository.dart';
import 'package:my_flutter_app/domain/models/task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({
    required this.taskRepository,
  }) : super(TaskInitial()) {
    on<FetchTasks>(
      (event, emit) async {
        try {
          emit(TaskLoading());
          emit(TaskLoaded(tasks: taskRepository.getTasks()));
        } catch (error) {
          emit(TaskError(message: 'Failed to fetch tasks: $error'));
        }
      },
    );
    on<AddTask>(
      (event, emit) async {
        try {
          emit(TaskLoading());
          await taskRepository.addTask(event.task);
          emit(TaskLoaded(tasks: taskRepository.getTasks()));
        } catch (error) {
          emit(TaskError(message: 'Failed to add task $error'));
        }
      },
    );
    on<UpdateTask>(
      (event, emit) async {
        try {
          emit(TaskLoading());
          await taskRepository.updateTask(event.task);
          emit(TaskLoaded(tasks: taskRepository.getTasks()));
        } catch (error) {
          emit(TaskError(message: 'Failed to update task $error'));
        }
      },
    );
    on<DeleteTask>(
      (event, emit) async {
        try {
          emit(TaskLoading());
          await taskRepository.deleteTask(event.task);
          emit(TaskLoaded(tasks: taskRepository.getTasks()));
        } catch (error) {
          emit(TaskError(message: 'Failed to delete task $error'));
        }
      },
    );
  }
}
