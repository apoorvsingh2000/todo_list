import 'package:flutter/foundation.dart';
import 'package:todo_list/models/task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  List<Task> _tasks = [
    Task(name: 'Buy milk', dateTime: '2022-09-12 12:45'),
    Task(name: 'Buy eggs', dateTime: '2022-09-12 12:46'),
    Task(name: 'Buy bread', dateTime: '2022-09-12 12:47'),
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  List<Task> getTasksList() => _tasks;

  void addTask(String newTaskTitle, String newDateTime) {
    final task = Task(name: newTaskTitle, dateTime: newDateTime);
    _tasks.add(task);
    _tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
