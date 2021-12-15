import 'package:cupertino_date_time_picker/cupertino_date_time_picker.dart';
import 'package:flutter/material.dart';

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatePickerBottomSheetState();
}

const String minDateTime = '2010-05-12';
const String maxDateTime = '2030-11-25';
const String initDateTime = '2021-08-31';

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  bool _showTitle = true;

  DateTimePickerLocale? _locale = DateTimePickerLocale.en_us;
  final List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  final TextEditingController _formatCtrl = TextEditingController();

  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(initDateTime);
  }

  @override
  Widget build(BuildContext context) {
    // create locale radio list
    List<Widget> radios = [];
    for (var locale in _locales) {
      radios.add(Container(
        margin: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio(
              value: locale,
              groupValue: _locale,
              onChanged: (dynamic value) {
                setState(() {
                  _locale = value;
                });
              },
            ),
            Text(locale
                .toString()
                .substring(locale.toString().indexOf('.') + 1)),
          ],
        ),
      ));
    }

    TextStyle hintTextStyle = Theme.of(context)
        .textTheme
        .subtitle1!
        .apply(color: const Color(0xFF999999));
    return Scaffold(
      appBar: AppBar(title: const Text('DatePicker Bottom Sheet')),
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
                      child: Text('init DateTime:', style: hintTextStyle)),
                  Text(initDateTime,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),

            // show title widget checkbox
            Row(
              children: [
                const Text('show title'),
                Checkbox(
                  value: _showTitle,
                  onChanged: (value) {
                    setState(() {
                      _showTitle = value!;
                    });
                  },
                )
              ],
            ),

            // date format input field
            TextField(
              controller: _formatCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Date Format',
                hintText: 'yyyy-MM-dd',
                hintStyle: TextStyle(color: Colors.black26),
              ),
              onChanged: (value) {
                _format = value;
              },
            ),

            // locale check radio group
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Locale: '),
                  Wrap(direction: Axis.horizontal, children: radios)
                ],
              ),
            ),

            // selected date
            Container(
              margin: const EdgeInsets.only(top: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Selected Date:',
                      style: Theme.of(context).textTheme.subtitle1),
                  Container(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      '${_dateTime!.year}-${_dateTime!.month.toString().padLeft(2, '0')}-${_dateTime!.day.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // display DatePicker floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _showDatePicker,
        tooltip: 'Show DatePicker',
        child: const Icon(Icons.date_range),
      ),
    );
  }

  /// Display date picker.
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: '选择出生日期',
        showTitle: _showTitle,
        selectionOverlayColor: Colors.blue,
        // showTitle: false,
        // titleHeight: 80,
        // confirm: const Text('确定', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale!,
      onClose: () => debugPrint("----- onClose -----"),
      onCancel: () => debugPrint('onCancel'),
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
