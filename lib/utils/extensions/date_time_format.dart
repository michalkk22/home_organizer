extension Formats on DateTime {
  String get dayTimeFormat {
    if (minute < 10) {
      return '$hour:0$minute';
    }
    return '$hour:$minute';
  }

  String get dateTimeFormat => '$dateFormat $dayTimeFormat';

  String get dateFormat {
    String monthText = month < 10 ? '0$month' : '$month';
    String dayText = day < 10 ? '0$day' : '$day';
    return '$year.$monthText.$dayText';
  }

  String get yearMonthFormat {
    String monthText = month < 10 ? '0$month' : '$month';
    return '$year.$monthText';
  }
}
