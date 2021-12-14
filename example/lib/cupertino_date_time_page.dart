import 'package:flutter/material.dart';

import './date_picker_bottom_sheet.dart';
import './date_picker_in_page.dart';
import 'date_time_picker_bottom_sheet.dart';
import 'date_time_picker_in_page.dart';
import './time_picker_bottom_sheet.dart';
import './time_picker_in_page.dart';

class CupertinoDateTimePage extends StatelessWidget {
  const CupertinoDateTimePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 16.0);
    return Scaffold(
      appBar: AppBar(title: const Text('Date Picker Demo')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: Text("DatePicker Bottom Sheet", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const DatePickerBottomSheet();
                }));
              },
            ),
            ElevatedButton(
              child: Text("DatePicker In Page", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const DatePickerInPage();
                }));
              },
            ),
            ElevatedButton(
              child: Text("TimePicker Bottom Sheet", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const TimePickerBottomSheet();
                }));
              },
            ),
            ElevatedButton(
              child: Text("TimePicker In Page", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const TimePickerInPage();
                }));
              },
            ),
            ElevatedButton(
              child: Text("DateTimePicker Bottom Sheet", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const DateTimePickerBottomSheet();
                }));
              },
            ),
            ElevatedButton(
              child: Text("DateTimePicker In Page", style: textStyle),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const DateTimePickerInPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
