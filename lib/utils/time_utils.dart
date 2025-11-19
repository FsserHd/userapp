

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../flutter_flow/flutter_flow_util.dart';

class TimeUtils{

  static String convertMonthDateYear(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("MMM dd, yyyy").format(inputDate);
  }

  static String convertDayMonthYear(String date){
    DateTime inputDate = DateFormat("dd-MM-yyyy").parse(date);
    return DateFormat("MMM dd, yyyy").format(inputDate);
  }

  static String convertddMMyyyy(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("dd-MM-yyyy").format(inputDate);
  }

  static String convertMonthOnly(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("MMM").format(inputDate);
  }
  static String convertYearOnly(String date){
    DateTime inputDate = DateFormat("yyyy-MM-dd").parse(date);
    return DateFormat("yyyy").format(inputDate);
  }

  static String convertUTC(String date){
    final DateTime dateTime = DateTime.parse(date);
    String formattedDateTime = DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
    return formattedDateTime;
  }

  static String getDateComparison(DateTime currentDate, String date) {
    DateTime targetDate = DateTime.parse(date);
    if (currentDate.year == targetDate.year &&
        currentDate.month == targetDate.month &&
        currentDate.day == targetDate.day) {
      return 'Today';
    } else if (currentDate.year == targetDate.year &&
        currentDate.month == targetDate.month &&
        currentDate.day + 1 == targetDate.day) {
      return 'Tomorrow';
    } else {
      return convertUTC(targetDate.toString()); // Format: YYYY-MM-DD
    }
  }

  static String getTimeStampToDate(int timeStamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
    return formattedDate;
  }

  static String showDifferenceTime(String time){

    DateTime now = DateTime.now();
    DateTime givenDateTime = DateTime(now.year, now.month, now.day, int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
    Duration diff = givenDateTime.difference(now);
    if (diff.isNegative) {
      givenDateTime = givenDateTime.add(Duration(days: 1));
      diff = givenDateTime.difference(now);
    }
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    return '${hours > 0 ? '$hours hour${hours > 1 ? 's' : ''} ' : ''}${minutes > 0 ? '$minutes min${minutes > 1 ? 's' : ''}' : ''}';
  }

  static int getTimestamp() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch ~/ 1000;  // Unix timestamp in seconds
  }

  static String formatedTime(String time){
    DateFormat inputFormat = DateFormat("HH:mm");
    DateTime dateTime = inputFormat.parse(time);
    DateFormat outputFormat = DateFormat("hh:mm a");
    return outputFormat.format(dateTime);
  }

}