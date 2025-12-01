import 'package:flutter/material.dart';

class DateHelper {
  Future<DateTime?> selectDate(BuildContext context,{DateTime? firstDate}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:firstDate?? DateTime.now(),
      firstDate:firstDate?? DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
