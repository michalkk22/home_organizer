extension Formats on DateTime {
  String get dayTimeFormat {
    if (minute < 10) {
      return '$hour:0$minute';
    }
    return '$hour:$minute';
  }

  String get dateTimeFormat => '$year.$month.$day $dayTimeFormat';
}
