class Task {
  final String name;
  bool isDone;
  String dateTime;

  Task({this.name, this.isDone = false, this.dateTime});

  void toggleDone() {
    isDone = !isDone;
  }

  String getDateTime() {
    return dateTime;
  }
}
