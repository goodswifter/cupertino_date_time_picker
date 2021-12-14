import 'package:flutter/material.dart';
import '/src/tool/gaps.dart';

import '../date_picker_constants.dart';
import '../date_picker_theme.dart';
import '../i18n/date_picker_i18n.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DatePickerTitleWidget extends StatelessWidget {
  const DatePickerTitleWidget({
    Key? key,
    required this.pickerTheme,
    required this.locale,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final DateTimePickerTheme pickerTheme;
  final DateTimePickerLocale locale;
  final DateVoidCallback onCancel, onConfirm;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.headerWidget != null) {
      return pickerTheme.headerWidget!;
    }
    return Column(
      children: [
        Container(
          height: pickerTheme.titleHeight - headerDividerHeight,
          decoration: BoxDecoration(
            color: pickerTheme.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: _renderCancelWidget(context),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: _renderTitleWidget(context),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: _renderConfirmWidget(context),
                ),
              ),
            ],
          ),
        ),
        Gaps.line,
      ],
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.cancel == null) {
        return const Offstage();
      }
    }

    Widget? cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
            color: Theme.of(context).unselectedWidgetColor,
            fontSize: 17.0,
          );
      cancelWidget = Text(
        DatePickerI18n.getLocaleCancel(locale),
        style: textStyle,
      );
    }

    return SizedBox(
      height: pickerTheme.titleHeight,
      child: TextButton(
        child: cancelWidget,
        onPressed: () => onCancel(),
      ),
    );
  }

  /// render cancel button widget
  Widget _renderTitleWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // title is empty
      if (pickerTheme.title.isEmpty) {
        return const Offstage();
      }
    }

    TextStyle textStyle = pickerTheme.titleTextStyle ??
        const TextStyle(
          color: Colors.black87,
          fontSize: 17.0,
        );

    return SizedBox(
      child: Text(
        pickerTheme.title,
        style: textStyle,
      ),
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.confirm == null) {
        return const Offstage();
      }
    }

    Widget? confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17.0,
          );
      confirmWidget = Text(
        DatePickerI18n.getLocaleDone(locale),
        style: textStyle,
      );
    }

    return SizedBox(
      height: pickerTheme.titleHeight,
      child: TextButton(
        child: confirmWidget,
        onPressed: () => onConfirm(),
      ),
    );
  }

  bool isCustomTitleWidget() {
    return pickerTheme.headerWidget != null;
  }
}
