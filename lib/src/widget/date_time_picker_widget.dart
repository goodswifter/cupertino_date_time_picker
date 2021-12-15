import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/src/tool/date_picker_tool.dart';
import '/src/tool/date_time_extension.dart';
import '/src/widget/picker_column_component_widget.dart';

import '../date_picker_constants.dart';
import '../date_picker_theme.dart';
import '../date_time_formatter.dart';
import '../i18n/date_picker_i18n.dart';
import 'date_picker_title_widget.dart';

class DateTimePickerWidget extends StatefulWidget {
  DateTimePickerWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat = dateTimePickerTimeFormat,
    this.dateFormatSeparator = dateFormatSeparators,
    this.locale = dateTimePickerLocaleDefault,
    this.pickerTheme = DateTimePickerTheme.dafault,
    this.minuteDivider = 1,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.onMonthChangeStartWithFirstDate = false,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDateTime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDateTime);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime? minDateTime, maxDateTime, initDateTime;
  final String dateFormat;
  final String dateFormatSeparator;
  final DateTimePickerLocale locale;
  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final int minuteDivider;
  final bool onMonthChangeStartWithFirstDate;

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime _minTime, _maxTime, _initTime;
  late int _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond;
  late int _minuteDivider;
  late List<int> _yearRange,
      _monthRange,
      _dayRange,
      _hourRange,
      _minuteRange,
      _secondRange;
  late FixedExtentScrollController _yearScrollCtrl,
      _monthScrollCtrl,
      _dayScrollCtrl,
      _hourScrollCtrl,
      _minuteScrollCtrl,
      _secondScrollCtrl;

  late Map<String, FixedExtentScrollController> _scrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  @override
  void initState() {
    super.initState();

    // check minTime value
    _minTime = widget.minDateTime ?? DateTime.parse(datePickerMinDateTime);
    // check maxTime value
    _maxTime = widget.maxDateTime ?? DateTime.parse(datePickerMaxDateTime);
    // check initTime value
    _initTime = widget.initDateTime ?? DateTime.now();
    // limit initTime value
    if (_initTime.compareTo(_minTime) < 0) {
      _initTime = _minTime;
    }
    if (_initTime.compareTo(_maxTime) > 0) {
      _initTime = _maxTime;
    }
    _currYear = _initTime.year;
    _currMonth = _initTime.month;
    _currDay = _initTime.day;
    _currHour = _initTime.hour;
    _currMinute = _initTime.minute;
    _currSecond = _initTime.second;

    _minuteDivider = widget.minuteDivider;

    // limit the range of year
    _yearRange = _calcYearRange();
    _currYear = min(max(_minTime.year, _currYear), _maxTime.year);
    // limit the range of month
    _monthRange = _calcMonthRange();
    _currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);
    // limit the range of date
    _dayRange = _calcDayRange();
    _currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // limit the range of hour
    _hourRange = _calcHourRange();
    _currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    _minuteRange = _calcMinuteRange();
    _currMinute = min(max(_minuteRange.first, _currMinute), _minuteRange.last);

    // limit the range of second
    _secondRange = _calcSecondRange();
    _currSecond = min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _yearScrollCtrl =
        FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(
        initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl =
        FixedExtentScrollController(initialItem: _currDay - _dayRange.first);
    _hourScrollCtrl =
        FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController(
        initialItem: (_currMinute - _minuteRange.first) ~/ _minuteDivider);
    _secondScrollCtrl = FixedExtentScrollController(
        initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {
      DateTimeType.year.value: _yearScrollCtrl,
      DateTimeType.month.value: _monthScrollCtrl,
      DateTimeType.day.value: _dayScrollCtrl,
      DateTimeType.hour.value: _hourScrollCtrl,
      DateTimeType.minute.value: _minuteScrollCtrl,
      DateTimeType.second.value: _secondScrollCtrl
    };
    _valueRangeMap = {
      DateTimeType.year.value: _yearRange,
      DateTimeType.month.value: _monthRange,
      DateTimeType.day.value: _dayRange,
      DateTimeType.hour.value: _hourRange,
      DateTimeType.minute.value: _minuteRange,
      DateTimeType.second.value: _secondRange
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.headerWidget != null ||
        widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        locale: widget.locale,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: [titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    widget.onCancel?.call();

    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime dateTime = DateTime(
          _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected datetime changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(
          _currYear, _currMonth, _currDay, _currHour, _currMinute, _currSecond);
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    if (scrollCtrl == null) {
      throw Exception('Illegal format $format');
    }
    return scrollCtrl!;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    List<int>? valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    if (valueRange == null) {
      throw Exception('Illegal format $format');
    }
    return valueRange!;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = [];
    List<String> formatArr = DateTimeFormatter.splitDateFormat(
        widget.dateFormat,
        dateFormatSeparator: widget.dateFormatSeparator);
    for (var format in formatArr) {
      List<int> valueRange = _findPickerItemRange(format);

      Widget pickerColumn = PickerColumnComponentWidget(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        minuteDivider: widget.minuteDivider,
        locale: widget.locale,
        pickerHeight: widget.pickerTheme.pickerHeight,
        itemHeight: widget.pickerTheme.itemHeight,
        itemTextStyle: widget.pickerTheme.itemTextStyle,
        backgroundColor: widget.pickerTheme.backgroundColor,
        selectionOverlayColor: widget.pickerTheme.selectionOverlayColor,
        valueChanged: (value) {
          if (format.contains(DateTimeType.year.value)) {
            _changeYearSelection(value);
          } else if (format.contains(DateTimeType.month.value)) {
            _changeMonthSelection(value);
          } else if (format.contains(DateTimeType.day.value)) {
            _changeDaySelection(value);
          } else if (format.contains(DateTimeType.hour.value)) {
            _changeHourSelection(value);
          } else if (format.contains(DateTimeType.minute.value)) {
            _changeMinuteSelection(value);
          } else if (format.contains(DateTimeType.second.value)) {
            _changeSecondSelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    int dayOfMonth = _dayRange.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    int value = _hourRange.first + index;
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of minute picker
  void _changeMinuteSelection(int index) {
    int value = _minuteRange.first + index * _minuteDivider;
    debugPrint('_changeMinuteSelection $index ${_minuteRange.first}');
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index;
    if (_currSecond != value) {
      _currSecond = value;
      _onSelectedChange();
    }
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) return;

    _isChangeTimeRange = true;

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange.first != monthRange.first ||
        _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged =
        _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      if (!widget.onMonthChangeStartWithFirstDate) {
        max(min(_currDay, dayRange.last), dayRange.first);
      } else {
        _currDay = dayRange.first;
      }
    }

    List<int> hourRange = _calcHourRange();
    bool hourRangeChanged = _hourRange.first != hourRange.first ||
        _hourRange.last != hourRange.last;
    if (hourRangeChanged) {
      // selected day changed
      _currHour = max(min(_currHour, hourRange.last), hourRange.first);
    }

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first ||
        _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first ||
        _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;
      _hourRange = hourRange;
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap[DateTimeType.month.value] = monthRange;
      _valueRangeMap[DateTimeType.day.value] = dayRange;
      _valueRangeMap[DateTimeType.hour.value] = hourRange;
      _valueRangeMap[DateTimeType.minute.value] = minuteRange;
      _valueRangeMap[DateTimeType.second.value] = secondRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(currDay - dayRange.first);
      }
    }

    if (hourRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currHour = _currHour;
      _hourScrollCtrl.jumpToItem(hourRange.last - hourRange.first);
      if (currHour < hourRange.last) {
        _hourScrollCtrl.jumpToItem(currHour - hourRange.first);
      }
    }

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currMinute;
      _minuteScrollCtrl
          .jumpToItem((minuteRange.last - minuteRange.first) ~/ _minuteDivider);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int yearIndex = _currYear - _minTime.year;
    int monthIndex = _currMonth - _monthRange.first;
    int dayIndex = _currDay - _dayRange.first;
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = _currMinute - _minuteRange.first;
    return [yearIndex, monthIndex, dayIndex, hourIndex, minuteIndex];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minTime.year, _maxTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    int minDay = 1;
    int maxDay = DatePickerTool.calcDayCountOfMonth(
      currentMonth: _currMonth,
      currentYear: _currYear,
    );
    int minYear = _minTime.year;
    int maxYear = _maxTime.year;
    int minMonth = _minTime.month;
    int maxMonth = _maxTime.month;
    currMonth ??= _currMonth;
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxTime.day;
    }
    return [minDay, maxDay];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    int minHour = 0, maxHour = 23;
    if (_currYear == _minTime.year &&
        _currMonth == _minTime.month &&
        _currDay == _minTime.day) {
      minHour = _minTime.hour;
    }
    if (_currYear == _maxTime.year &&
        _currMonth == _maxTime.month &&
        _currDay == _maxTime.day) {
      maxHour = _maxTime.hour;
    }
    return [minHour, maxHour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    currHour ??= _currHour;

    if (_currYear == _minTime.year &&
        _currMonth == _minTime.month &&
        _currDay == _minTime.day &&
        _currHour == _minTime.hour) {
      // selected minimum day、hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (_currYear == _maxTime.year &&
        _currMonth == _maxTime.month &&
        _currDay == _maxTime.day &&
        _currHour == _minTime.hour) {
      // selected maximum day、hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({currHour, currMinute}) {
    int minSecond = 0, maxSecond = 59;

    currHour ??= _currHour;
    currMinute ??= _currMinute;

    if (_currYear == _minTime.year &&
        _currMonth == _minTime.month &&
        _currDay == _minTime.day &&
        _currHour == _minTime.hour &&
        _currMinute == _minTime.minute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (_currYear == _maxTime.year &&
        _currMonth == _maxTime.month &&
        _currDay == _maxTime.day &&
        _currHour == _minTime.hour &&
        _currMinute == _minTime.minute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
