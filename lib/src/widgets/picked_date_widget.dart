import 'package:flutter/material.dart';

Future showDatePickerCustom({context}) async {
  DateTime selectedDate = DateTime.now();
  var picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
    return picked.toString().substring(0, 10);
  } else {
    return selectedDate.toString().substring(0, 10);
  }
}

DateTime _startDate = DateTime.now();
DateTime _endDate = DateTime.now();

Future<void> selectDateRange(BuildContext context, Function? dataFecha) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2021),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(
      start: _startDate,
      end: _endDate,
    ),
  );

  if (picked != null) {
    _startDate = picked.start;
    _endDate = picked.end;
    dataFecha!(_startDate.toString().substring(0, 10),
        _endDate.toString().substring(0, 10));
  }
}
