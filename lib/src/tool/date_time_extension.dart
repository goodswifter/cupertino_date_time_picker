///
/// Author       : zhongaidong
/// Date         : 2021-12-01 17:20:40
/// Description  :
///

enum DateTimeType {
  year, // 年
  month, // 月
  // week, // 星期
  day, // 日
  hour, // 时
  minute, // 分
  second, // 秒
}

extension DateTimeTypeExtension on DateTimeType {
  // String get value => ['y', 'M', 'E', 'd', 'H', 'm', 's'][index];
  String get value => ['y', 'M', 'd', 'H', 'm', 's'][index];
}
