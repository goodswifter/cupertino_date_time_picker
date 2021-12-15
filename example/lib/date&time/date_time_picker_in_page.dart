import 'package:cupertino_date_time_picker/cupertino_date_time_picker.dart';
import 'package:flutter/material.dart';

///
/// @author dylan wu
/// @since 2019-05-10
class DateTimePickerInPage extends StatefulWidget {
  const DateTimePickerInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateTimePickerInPageState();
}

const String minDateTime = '2010-05-15 20:10:55';
const String maxDateTime = '2019-07-01 12:30:40';
const String initDateTime = '2019-05-16 09:00:58';
const String dateFormat = 'yyyy-MM-dd,H时:m分';

class _DateTimePickerInPageState extends State<DateTimePickerInPage> {
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.parse(initDateTime);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle hintTextStyle =
        Theme.of(context).textTheme.subtitle1!.apply(color: const Color(0xFF999999));
    return Scaffold(
      appBar: AppBar(title: const Text("DateTimePicker In Page")),
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
                    child: Text('max DateTime:', style: hintTextStyle),
                  ),
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

            // show custom title widget
            Row(
              children: [
                Text('show custom title', style: hintTextStyle),
                Checkbox(value: true, onChanged: (value) {}),
              ],
            ),

            // custom title height
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: Text('custom title height:', style: hintTextStyle),
                  ),
                  Text('40.0', style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // date time picker widget
            Container(
              margin: const EdgeInsets.only(top: 8.0, bottom: 40.0),
              child: DateTimePickerWidget(
                minDateTime: DateTime.parse(minDateTime),
                maxDateTime: DateTime.parse(maxDateTime),
                initDateTime: DateTime.parse(initDateTime),
                dateFormat: dateFormat,
                pickerTheme: DateTimePickerTheme(
                  showTitle: false,
                  headerWidget: Container(
                    width: double.infinity,
                    height: 40.0,
                    alignment: Alignment.center,
                    child: const Text('Date Time Picker Title'),
                    decoration: const BoxDecoration(color: Color(0xFFc0ca33)),
                  ),
                  backgroundColor: const Color(0xFFf0f4c3),
                ),
                onChange: (dateTime, selectedIndex) {
                  setState(() {
                    _dateTime = dateTime;
                  });
                },
              ),
            ),

            // selected date time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected DateTime:',
                    style: Theme.of(context).textTheme.subtitle1),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _dateTime != null
                        ? '${_dateTime!.year}-${_dateTime!.month.toString().padLeft(2, '0')}-${_dateTime!.day.toString().padLeft(2, '0')} ${_dateTime!.hour.toString().padLeft(2, '0')}:${_dateTime!.minute.toString().padLeft(2, '0')}:${_dateTime!.second.toString().padLeft(2, '0')}'
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
