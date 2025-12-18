extension DateTimeOperations on DateTime {
  DateTime addMonth({int value = 1}) {
    return DateTime(
      year,
      month + value,
      1,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
