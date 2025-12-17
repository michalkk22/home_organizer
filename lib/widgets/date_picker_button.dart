import 'package:flutter/material.dart';
import 'package:home_organizer/utils/extensions/date_time_format.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({super.key, required this.controller});
  final ValueNotifier<DateTime> controller;

  Future<void> _updateDate(BuildContext context) async {
    final newDate =
        await showDatePicker(
          context: context,
          initialDate: controller.value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(Duration(days: 356)),
        ) ??
        controller.value;
    controller.value = newDate;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: controller,
      builder: (_, date, __) {
        return TextButton(
          onPressed: () => _updateDate(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date.dateFormat),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        );
      },
    );
  }
}
