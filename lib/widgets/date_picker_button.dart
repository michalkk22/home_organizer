import 'package:flutter/material.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';

class DatePickerButton extends StatefulWidget {
  const DatePickerButton({super.key, required this.controller});
  final DatePickerButtonController controller;

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = widget.controller.date;
  }

  Future<void> _updateDate() async {
    date =
        await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(Duration(days: 356)),
        ) ??
        date;
    widget.controller.set(date);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _updateDate(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(date.dateFormat), Icon(Icons.arrow_drop_down)],
      ),
    );
  }
}

class DatePickerButtonController {
  DateTime? _date;

  DatePickerButtonController({DateTime? date}) : _date = date;

  void set(DateTime date) => _date = date;
  DateTime get date => _date ?? DateTime.now();
}
