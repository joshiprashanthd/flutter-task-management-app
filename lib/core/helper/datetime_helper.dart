class DateTimeHelper{
  static DateTime get firstDateOfWeek {
    return DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  }

  static DateTime get lastDateOfWeek {
    return DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
  }

  static DateTime get firstDateOfMonth{
    return DateTime.now().subtract(Duration(days: DateTime.now().day));
  }

  static DateTime get lastDateOfMonth{
    return DateTime.now().add(Duration(days: 30 - DateTime.now().day));
  }

  static DateTime firstDateOfWeekOfDay(DateTime datetime){
    return datetime.subtract(Duration(days: datetime.weekday));
  }

  static DateTime lastDateOfWeekOfDay(DateTime datetime){
    return datetime.add(Duration(days: 7 - datetime.weekday));
  }
}