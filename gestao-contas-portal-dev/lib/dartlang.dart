import 'package:advoga_dev/version.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:reflected_mustache/mustache.dart';

part 'dartlang.g.dart';

@mustache
@JsonSerializable()
class DartLang {
  String name;
  Version version;
  String message;

  DartLang({this.name, this.version, this.message});

  factory DartLang.fromJson(Map<String, dynamic> json) => _$DartLangFromJson(json);

  Map<String, dynamic> toJson() => _$DartLangToJson(this);
}