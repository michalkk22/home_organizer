import 'package:flutter/material.dart';

Future<DateTime?> defaultDatePicker(
  BuildContext context,
  DateTime initialDate,
) => showDatePicker(
  context: context,
  initialDate: initialDate,
  firstDate: DateTime(2020),
  lastDate: DateTime.now().add(Duration(days: 356)),
);
