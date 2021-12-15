import 'package:cupertino_date_time_picker/cupertino_date_time_picker.dart';
import 'package:flutter/material.dart';

///
/// @author dylan wu
/// @since 2019-05-10
class DatePickerInPage extends StatefulWidget {
  const DatePickerInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatePickerInPageState();
}

const String minDateTime = '2010-05-12';
const String maxDateTime = '2021-11-25';
const String initDateTime = '2019-05-17';
const String dateFormat = 'MM月|d日,yyyy年';

class _DatePickerInPageState extends State<DatePickerInPage> {
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.parse(initDateTime);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle hintTextStyle = Theme.of(context)
        .textTheme
        .subtitle1!
        .apply(color: const Color(0xFF999999));
    return Scaffold(
      appBar: AppBar(title: const Text("DatePicker In Page")),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // min datetime hint
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 115.0,
                    child: Text('min DateTime:', style: hintTextStyle),
                  ),
                  Text(minDateTime,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // max datetime hint
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                      width: 115.0,
                      child: Text('max DateTime:', style: hintTextStyle)),
                  Text(maxDateTime,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // init datetime hint
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 115.0,
                    child: Text('init DateTime:', style: hintTextStyle),
                  ),
                  Text(initDateTime,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // date format
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 115.0,
                    child: Text('Date Format:', style: hintTextStyle),
                  ),
                  Text(dateFormat,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // date picker theme
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    titlePadding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    title: const Text("DateTimePickerTheme"),
                    contentPadding: const EdgeInsets.all(16.0),
                    content: const Text(
                      '''
DateTimePickerTheme(
        backgroundColor: Color(0xFF80cbc4),
        cancelTextStyle: TextStyle(color: Colors.white),
        confirmTextStyle: TextStyle(color: Colors.black),
        itemTextStyle: TextStyle(color: Colors.deepOrange),
        pickerHeight: 300.0,
        titleHeight: 24.0,
        itemHeight: 30.0,
)
                    ''',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Text('DateTimePickerTheme  ', style: hintTextStyle),
                    const Icon(Icons.remove_red_eye, color: Color(0xFF03a9f4)),
                  ],
                ),
              ),
            ),

            // date picker widget
            Container(
              margin: const EdgeInsets.only(top: 24.0, bottom: 40.0),
              child: DateTimePickerWidget(
                minDateTime: DateTime.parse(minDateTime),
                maxDateTime: DateTime.parse(maxDateTime),
                initDateTime: DateTime.parse(initDateTime),
                dateFormat: dateFormat,
                pickerTheme: const DateTimePickerTheme(
                  backgroundColor: Color(0xFFb2dfdb),
                  cancelTextStyle: TextStyle(color: Colors.white),
                  confirmTextStyle: TextStyle(color: Colors.black),
                  itemTextStyle: TextStyle(color: Colors.deepOrange),
                  pickerHeight: 300.0,
                  titleHeight: 44.0,
                  itemHeight: 30.0,
                ),
                onChange: (dateTime, selectedIndex) {
                  setState(() {
                    _dateTime = dateTime;
                  });
                },
              ),
            ),

            // selected date
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Selected Date:',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    _dateTime != null
                        ? '${_dateTime!.year}-${_dateTime!.month.toString().padLeft(2, '0')}-${_dateTime!.day.toString().padLeft(2, '0')}'
                        : '',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
