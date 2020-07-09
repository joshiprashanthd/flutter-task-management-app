class DateString {
  static List<String> months = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  static List<String> weekdays = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static String dynamicTime(DateTime dateTime) {
    if (dateTime.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inHours > 0 && dateTime.difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).inHours < 24 ) {
      return "TODAY ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else if (DateTime.now().difference(dateTime).inDays < 0) {
      return "${weekdays[dateTime.weekday].substring(0, 3).toUpperCase()} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    } else {
      return "${dateTime.day} ${months[dateTime.month].substring(0, 3).toUpperCase()} ${dateTime.year}";
    }
  }

  static String staticTime(DateTime dateTime, {bool onlyDate: false}) {
    return !onlyDate
        ? "${dateTime.day} ${months[dateTime.month].substring(0, 3).toUpperCase()} ${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}"
        : "${dateTime.day} ${months[dateTime.month].substring(0, 3).toUpperCase()} ${dateTime.year} ";
  }
}
