extension DateTimeOperations on DateTime {
  DateTime addMonth({int value = 1}) {
    return DateTime(
      year,
      month + value,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
