import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/bloc/task_bloc/task_bloc.dart';
import 'package:my_flutter_app/domain/models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  Widget _buildTaskList(Stream<List<Task>> tasks) {
    return StreamBuilder<List<Task>>(
      stream: tasks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final taskList = snapshot.data!;
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return ListTile(
                title: Text(task.title ?? ''),
                subtitle: Text(task.description ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditTaskDialog(context, task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteTaskDialog(context, task);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to fetch tasks'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                context.read<TaskBloc>().add(
                      AddTask(
                        task: Task(
                          title: title,
                          description: description,
                          completed: false,
                        ),
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                context.read<TaskBloc>().add(
                      UpdateTask(
                        task: Task(
                          id: task.id,
                          title: title,
                          description: description,
                        ),
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TaskBloc>().add(
                      DeleteTask(
                        task: task,
                      ),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(FetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TaskLoaded) {
            return _buildTaskList(state.tasks);
          } else if (state is TaskError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
