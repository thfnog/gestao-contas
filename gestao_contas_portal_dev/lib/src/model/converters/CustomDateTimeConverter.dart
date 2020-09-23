import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

final formatterDate = new DateFormat('dd/MM/yyyy');
final formatterMonth = new DateFormat('MMMM');
final formatterTime = new DateFormat('HH:mm:ss');
final formatterTimeWithoutSec = new DateFormat('HH:mm');
final formatterDateTime = new DateFormat('dd/MM/yyyy HH:mm:ss');
final formatterDateTimeEN = new DateFormat('yyyy-MM-dd HH:mm:ss');

class CustomDateTimeConverter implements JsonConverter<DateTime, List> {
  const CustomDateTimeConverter();

  @override
  DateTime fromJson(List json) {
    if (json == null) return null;
    return new DateTime(json[0], json[1], json[2], json[3], json[4], json[5]);
  }

  DateTime fromJsonString(String json) {
    if (json == null) return null;
    return DateTime.parse(json);
  }

  DateTime fromJsonStringPT(String json) {
    if (json == null) return null;
    var split = json.split("/");
    if (split.length == 3) {
      String dateFormatted = split[2] + "-" + split[1] + "-" + split[0];
      return const CustomDateTimeConverter().fromJsonString(dateFormatted);
    }
    return null;
  }

  TimeOfDay fromTimeJsonString(String json) {
    if (json == null) return null;
    return TimeOfDay(hour: int.parse(json.split(":")[0]), minute: int.parse(json.split(":")[1]));
  }

  @override
  List toJson(DateTime json) {
    List list = new List();
    list.add(json.year.toString());
    list.add(json.month.toString());
    list.add(json.day.toString());
    list.add(json.hour.toString());
    list.add(json.minute.toString());
    list.add(json.second.toString());

   return list;
  }

  String toJsonString(DateTime json) {
    if (json == null) return null;
    return formatterDateTimeEN.format(json);
  }

  String toJsonStringPT(DateTime json) {
    if (json == null) return null;
    return formatterDateTime.format(json);
  }

  String toTimeJsonString(TimeOfDay json) {
    if (json == null) return null;
    final now = new DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, json.hour, json.minute);
    return formatterTime.format(dateTime);
  }
}