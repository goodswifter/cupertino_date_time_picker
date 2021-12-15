import 'package:cupertino_date_time_picker/cupertino_date_time_picker.dart';
import 'package:flutter/material.dart';

class TimePickerBottomSheet extends StatefulWidget {
  const TimePickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimePickerBottomSheetState();
}

const String minDateTime = '2010-05-12 10:47:00';
const String maxDateTime = '2021-11-25 22:45:10';
const String initDateTime = '2019-05-17 18:13:15';

class _TimePickerBottomSheetState extends State<TimePickerBottomSheet> {
  String _format = 'HH:mm';
  final TextEditingController _formatCtrl = TextEditingController();

  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(initDateTime);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle hintTextStyle = Theme.of(context)
        .textTheme
        .subtitle1!
        .apply(color: const Color(0xFF999999));
    return Scaffold(
      appBar: AppBar(title: const Text('TimePicker Bottom Sheet')),
      body: Container(
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
                  Text(minDateTime.substring(11),
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
                  Text(maxDateTime.substring(11),
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
                  Text(initDateTime.substring(11),
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
                  Text('56.0', style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // date format input field
            TextField(
              controller: _formatCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Formatter',
                hintText: 'HH:mm:ss / H-m / H时.m分',
                hintStyle: TextStyle(color: Colors.black26),
              ),
              onChanged: (value) => _format = value,
            ),

            // selected time
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Selected Time:',
                      style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                        '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}:${_dateTime.second.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTimePicker,
        tooltip: 'Show TimePicker',
        child: const Icon(Icons.access_time),
      ),
    );
  }

  /// Display time picker.
  void _showTimePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: DateTime.parse(initDateTime),
      dateFormat: _format,
      pickerMode: DateTimePickerMode.time, // show TimePicker
      pickerTheme: DateTimePickerTheme(
        headerWidget: Container(
          decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
          height: 50,
          width: double.infinity,
          child: const Text('data'),
        ),
        // title: Container(
        //   decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
        //   width: double.infinity,
        //   height: 56.0,
        //   alignment: Alignment.center,
        //   child: const Text(
        //     'custom Title',
        //     style: TextStyle(color: Colors.green, fontSize: 24.0),
        //   ),
        // ),
        titleHeight: 56.0,
      ),
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }
}
