import 'dart:math';

import '/src/tool/date_time_extension.dart';
import 'date_picker.dart';
import 'date_picker_constants.dart';
import 'i18n/date_picker_i18n.dart';

const String dateFormatSeparators = r'[|,-/\._: ]+';

class DateTimeFormatter {
  /// Get default value of date format.
  static String generateDateFormat(DateTimePickerMode pickerMode) {
    switch (pickerMode) {
      case DateTimePickerMode.date:
        return dateTimePickerDateFormat;
      case DateTimePickerMode.time:
        return dateTimePickerTimeFormat;
      case DateTimePickerMode.dateTime:
        return dateTimePickerDateTimeFormat;
    }
  }

  /// Check if the date format is for day(contain y、M、d、E) or not.
  static bool isDayFormat(String format) {
    return format.contains(RegExp(r'[yMdE]'));
  }

  /// Check if the date format is for time(contain H、m、s) or not.
  static bool isTimeFormat(String format) {
    return format.contains(RegExp(r'[Hms]'));
  }

  /// Split date format to array.
  static List<String> splitDateFormat(String? dateFormat,
      {DateTimePickerMode? mode, String? dateFormatSeparator}) {
    if (dateFormat == null || dateFormat.isEmpty) {
      return [];
    }
    List<String> result =
        dateFormat.split(RegExp(dateFormatSeparator ?? dateFormatSeparators));
    if (mode == DateTimePickerMode.dateTime) {
      // datetime mode need join day format
      List<String> temp = [];
      StringBuffer dayFormat = StringBuffer();
      for (int i = 0; i < result.length; i++) {
        String format = result[i];
        if (isDayFormat(format)) {
          // find format pre-separator
          int end = dateFormat.indexOf(format);
          if (end > 0) {
            int start = 0;
            if (i > 0) {
              start = dateFormat.indexOf(result[i - 1]) + result[i - 1].length;
            }
            dayFormat.write(dateFormat.substring(start, end));
          }
          dayFormat.write(format);
        } else if (isTimeFormat(format)) {
          temp.add(format);
        }
      }
      if (dayFormat.length > 0) {
        temp.insert(0, dayFormat.toString());
      } else {
        // add default date format
        temp.insert(0, dateTimePickerDateFormat);
      }
      result = temp;
    }
    return result;
  }

  /// Format datetime string
  static String formatDateTime(
      int value, String? format, DateTimePickerLocale locale) {
    if (format == null || format.isEmpty) {
      return value.toString();
    }

    String result = format;
    // format year text
    if (format.contains(DateTimeType.year.value)) {
      result = _formatYear(value, result, locale);
    }
    // format month text
    if (format.contains(DateTimeType.month.value)) {
      result = _formatMonth(value, result, locale);
    }
    // format day text
    if (format.contains(DateTimeType.day.value)) {
      result = _formatDay(value, result, locale);
    }
    // format week text
    // if (format.contains(DateTimeType.week.value)) {
    //   result = _formatWeek(value, result, locale);
    // }
    // format hour text
    if (format.contains(DateTimeType.hour.value)) {
      result = _formatHour(value, result, locale);
    }
    // format minute text
    if (format.contains(DateTimeType.minute.value)) {
      result = _formatMinute(value, result, locale);
    }
    // format second text
    if (format.contains(DateTimeType.second.value)) {
      result = _formatSecond(value, result, locale);
    }
    if (result == format) {
      return value.toString();
    }
    return result;
  }

  /// Format day display
  static String formatDate(
      DateTime dateTime, String? format, DateTimePickerLocale locale) {
    if (format == null || format.isEmpty) {
      return dateTime.toString();
    }

    String result = format;
    // format year text
    if (format.contains(DateTimeType.year.value)) {
      result = _formatYear(dateTime.year, result, locale);
    }
    // format month text
    if (format.contains(DateTimeType.month.value)) {
      result = _formatMonth(dateTime.month, result, locale);
    }
    // format day text
    if (format.contains(DateTimeType.day.value)) {
      result = _formatDay(dateTime.day, result, locale);
    }
    // if (format.contains('E')) {
    //   result = _formatWeek(dateTime.weekday, result, locale);
    // }
    if (result == format) {
      return dateTime.toString();
    }
    return result;
  }

  /// format year text
  static String _formatYear(
      int value, String format, DateTimePickerLocale locale) {
    if (format.contains('yyyy')) {
      // yyyy: the digit count of year is 4, e.g. 2019
      return format.replaceAll('yyyy', value.toString());
    } else if (format.contains('yy')) {
      // yy: the digit count of year is 2, e.g. 19
      return format.replaceAll('yy',
          value.toString().substring(max(0, value.toString().length - 2)));
    }
    return value.toString();
  }

  /// format month text
  static String _formatMonth(
      int value, String format, DateTimePickerLocale locale) {
    List<String>? months;
    if (format.contains('MMMM')) {
      // MMMM: the full name of month, e.g. January
      months = DatePickerI18n.getLocaleMonths(locale);
      if (months != null) {
        return format.replaceAll('MMMM', months[value - 1]);
      }
    } else if (format.contains('MMM')) {
      // MMM: the short name of month, e.g. Jan
      months = DatePickerI18n.getLocaleMonths(locale, false);
      if (months != null) {
        String month = months[value - 1];
        return format.replaceAll('MMM', month);
      }
    }

    return _formatNumber(value, format, 'M');
  }

  /// format day text
  static String _formatDay(
      int value, String format, DateTimePickerLocale locale) {
    return _formatNumber(value, format, 'd');
  }

  /// format week text
  // static String _formatWeek(
  //     int value, String format, DateTimePickerLocale locale) {
  //   if (format.contains('EEEE')) {
  //     // EEEE: the full name of week, e.g. Monday
  //     List<String>? weeks = DatePickerI18n.getLocaleWeeks(locale);
  //     if (weeks != null) {
  //       return format.replaceAll('EEEE', weeks[value - 1]);
  //     }
  //   }
  //   // EEE: the short name of week, e.g. Mon
  //   List<String>? weeks = DatePickerI18n.getLocaleWeeks(locale, false);
  //   if (weeks != null) {
  //     return format.replaceAll(RegExp(r'E+'), weeks[value - 1]);
  //   }
  //   return "";
  // }

  /// format hour text
  static String _formatHour(
      int value, String format, DateTimePickerLocale locale) {
    return _formatNumber(value, format, 'H');
  }

  /// format minute text
  static String _formatMinute(
      int value, String format, DateTimePickerLocale locale) {
    return _formatNumber(value, format, 'm');
  }

  /// format second text
  static String _formatSecond(
      int value, String format, DateTimePickerLocale locale) {
    return _formatNumber(value, format, 's');
  }

  /// format number, if the digit count is 2, will pad zero on the left
  static String _formatNumber(int value, String format, String unit) {
    if (format.contains('$unit$unit')) {
      return format.replaceAll('$unit$unit', value.toString().padLeft(2, '0'));
    } else if (format.contains(unit)) {
      return format.replaceAll(unit, value.toString());
    }
    return value.toString();
  }
}
