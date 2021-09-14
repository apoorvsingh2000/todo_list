import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newTaskTitle;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0),
        color: Color(0xff757575),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20.0),
            //   topRight: Radius.circular(20.0),
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Add Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              Column(
                children: [
                  DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString('dt', val);
                      print(val);
                    },
                  ),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    onChanged: (newText) {
                      newTaskTitle = newText;
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final newTaskDt = prefs.getString('dt');
                  print('wwwwwwwwwwwwwwwwwwwwwwwwwwww $newTaskDt');
                  Provider.of<TaskData>(context).addTask(newTaskTitle, newTaskDt);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TextButton(
// onPressed: () {
// DatePicker.showDatePicker(context,
// showTitleActions: true,
// minTime: DateTime(1950, 3, 5),
// maxTime: DateTime(2100, 6, 7), onChanged: (date) {
// print('change $date');
// }, onConfirm: (date) {
// print('confirm $date');
// }, currentTime: DateTime.now(), locale: LocaleType.en);
// },
// child: Text(
// 'show date time picker',
// style: TextStyle(color: Colors.blue),
// ),
// ),
// TextButton(
// onPressed: () {
// DatePicker.showTime12hPicker(context, showTitleActions: true,
// onChanged: (date) {
// print('change $date in time zone ' +
// date.timeZoneOffset.inHours.toString());
// }, onConfirm: (date) {
// print('confirm $date');
// }, currentTime: DateTime.now());
// },
// child: Text(
// 'show 12H time picker with AM/PM',
// style: TextStyle(color: Colors.blue),
// ),
// ),
