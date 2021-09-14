import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/task_data.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => deletePastTask());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              isChecked: task.isDone,
              taskTime: task.dateTime,
              checkboxCallback: (checkboxState) {
                taskData.updateTask(task);
              },
              longPressCallback: () {
                taskData.deleteTask(task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }

  void deletePastTask() {
    List<Task> taskList = Provider.of<TaskData>(context).getTasksList();
    for (int i = 0; i < taskList.length; i++) {
      print(DateTime.parse(taskList[i].dateTime));
      if (DateTime.parse(taskList[i].dateTime).isBefore(DateTime.now())) {
        Provider.of<TaskData>(context).deleteTask(taskList[i]);
      }
    }
  }
}
