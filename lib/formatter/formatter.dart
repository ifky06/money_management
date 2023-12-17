// convert DateTime object to a string  yyyymmdd
import 'package:intl/intl.dart';

String convertDateTimeToString(DateTime dateTime) {
  // year in the format yyyy
  String year = dateTime.year.toString();

  // month in the format mm
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }

  // day in the format dd
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }

  // final string in the format yyyymmdd
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

String convertMonthNumberToString(int monthNumber) {
  String monthName = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ][monthNumber - 1];
  return monthName;
}

String currencyFormat(int number) {
  return NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
      .format(number);
}
