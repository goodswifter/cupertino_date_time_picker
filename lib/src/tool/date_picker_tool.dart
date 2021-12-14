///
/// Author       : zhongaidong
/// Date         : 2021-12-01 16:56:15
/// Description  :
///

/// Solar months of 31 days.
const List<int> solarMonthsOf31Days = <int>[1, 3, 5, 7, 8, 10, 12];

class DatePickerTool {
  /// calculate the count of day in current month
  static int calcDayCountOfMonth(
      {required int currentMonth, required int currentYear}) {
    if (currentMonth == 2) {
      return isLeapYear(currentYear) ? 29 : 28;
    } else if (solarMonthsOf31Days.contains(currentMonth)) {
      return 31;
    }
    return 30;
  }

  /// whether or not is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }
}
