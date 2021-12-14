import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/cupertino_date_time_picker.dart';
import '/src/date_picker_theme.dart';
import '/src/date_time_formatter.dart';

///
/// Author       : zhongaidong
/// Date         : 2021-12-01 16:21:32
/// Description  :
///

class PickerColumnComponentWidget extends StatelessWidget {
  const PickerColumnComponentWidget({
    Key? key,
    required this.scrollCtrl,
    required this.valueRange,
    required this.format,
    required this.valueChanged,
    required this.minuteDivider,
    this.pickerHeight = dateTimePickerHeight,
    this.backgroundColor = dateTimePickerBackgroundColor,
    this.itemHeight = dateTimePickerItemHeight,
    this.itemTextStyle = dateTimePickerItemTextStyle,
    this.locale = dateTimePickerLocaleDefault,
    this.selectionOverlayColor = dateTimePickerSelectionOverlayColor,
  }) : super(key: key);

  final FixedExtentScrollController scrollCtrl;
  final List<int> valueRange;
  final String format;
  final ValueChanged<int> valueChanged;
  final int minuteDivider;
  final double pickerHeight;
  final Color backgroundColor;
  final double itemHeight;
  final TextStyle itemTextStyle;
  final DateTimePickerLocale locale;
  final Color selectionOverlayColor;

  @override
  Widget build(BuildContext context) {
    DateTimePickerTheme;
    Widget columnWidget = Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: pickerHeight,
      decoration: BoxDecoration(color: backgroundColor),
      child: CupertinoPicker.builder(
        backgroundColor: backgroundColor,
        scrollController: scrollCtrl,
        // selectionOverlay: widget.pickerTheme.selectionOverlay ??
        selectionOverlay: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: selectionOverlayColor),
            ),
          ),
        ),
        itemExtent: itemHeight,
        onSelectedItemChanged: valueChanged,
        childCount: format.contains('m')
            ? _calculateMinuteChildCount(valueRange, minuteDivider)
            : valueRange.last - valueRange.first + 1,
        itemBuilder: (context, index) {
          int value = valueRange.first + index;

          if (format.contains('m')) {
            value = minuteDivider * index + valueRange.first;
          }

          return _renderDatePickerItemComponent(value, format);
        },
      ),
    );
    return Expanded(
      flex: 1,
      child: columnWidget,
    );
  }

  _calculateMinuteChildCount(List<int> valueRange, int divider) {
    if (divider == 0) {
      debugPrint("Cant devide by 0");
      return (valueRange.last - valueRange.first + 1);
    }

    return (valueRange.last - valueRange.first + 1) ~/ divider;
  }

  /// render hour、minute、second picker item
  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format, locale),
        style: itemTextStyle,
      ),
    );
  }
}
